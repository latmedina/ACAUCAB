from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponse, HttpResponseNotFound
from django.contrib.auth.decorators import login_required
from django.db import connection
from django.core.serializers.json import DjangoJSONEncoder
from django.contrib import messages
from django.views.decorators.csrf import csrf_exempt
import json
import traceback
from datetime import datetime
from .forms import AsignarRolForm
from store.models import usuario, privilegio, rol, rol_privilegio
from empleados.utils import requiere_privilegio
from django.views.decorators.csrf import csrf_protect
from django.shortcuts import get_object_or_404

@login_required
def empleado_dashboard(request):
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado. Solo empleados pueden acceder a este módulo.')
        return redirect('login')
    
    empleado = request.user.fk_emp_car.fk_empleado

    # ⬇️ NUEVO: traer los privilegios desde la sesión
    privilegios = request.session.get('privilegios', [])

    context = {
        'empleado': empleado,
        'usuario': request.user,
        'privilegios': privilegios  # ⬅️ PASA ESTO AL TEMPLATE
    }

    return render(request, 'empleados/dashboard.html', context)


@login_required 
def empleado_reportes(request):
    """
    Vista para mostrar todos los reportes disponibles para empleados.
    """
    # Verificar que el usuario es un empleado
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado. Solo empleados pueden acceder a este módulo.')
        return redirect('login')
    
    reportes_disponibles = [
        {
            'nombre': 'Facturas de Venta',
            'descripcion': 'Generar reportes de facturas por ID de venta',
            'url': 'empleados:vista_factura',
            'icono': 'fa-file-invoice'
        },
        {
            'nombre': 'Órdenes de Compra',
            'descripcion': 'Generar reportes de órdenes de compra',
            'url': 'empleados:vista_orden_compra',
            'icono': 'fa-shopping-cart'
        },
        {
            'nombre': 'Productores en Eventos',
            'descripcion': 'Reporte de productores participando en eventos',
            'url': 'empleados:vista_reporte_productores',
            'icono': 'fa-users'
        },
        {
            'nombre': 'Eficiencia de Despacho',
            'descripcion': 'Reporte de tiempo promedio de despacho',
            'url': 'empleados:vista_reporte_eficiencia',
            'icono': 'fa-truck'
        },
        {
            'nombre': 'Histórico de Ofertas',
            'descripcion': 'Reporte de ofertas activas en un rango de fechas',
            'url': 'empleados:vista_reporte_ofertas',
            'icono': 'fa-tags'
        },
        {
            'nombre': 'Incumplimiento de Horario',
            'descripcion': 'Reporte de incumplimientos de horario',
            'url': 'empleados:vista_reporte_incumplimiento',
            'icono': 'fa-clock'
        },
        {
            'nombre': 'Órdenes Pendientes',
            'descripcion': 'Reporte de órdenes de compra pendientes',
            'url': 'empleados:vista_reporte_ordenes_pendientes',
            'icono': 'fa-hourglass-half'
        }
    ]
    
    context = {
        'empleado': request.user.fk_emp_car.fk_empleado,
        'reportes': reportes_disponibles,
    }
    
    return render(request, 'empleados/reportes.html', context)


# ========== VISTAS DE REPORTES (MOVIDAS DESDE store/views.py) ==========

# Facturas
@login_required
def vista_factura(request):
    """Vista para mostrar el reporte de facturas"""
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado.')
        return redirect('login')
    
    return render(request, 'empleados/reportes/factura_reporte.html')


def generar_reporte_venta_api(request, venta_id):
    """
    API endpoint que obtiene los datos para un reporte de venta específico.
    """
    if request.method != 'GET':
        return JsonResponse({'error': 'Método no permitido'}, status=405)

    try:
        with connection.cursor() as cursor:
            print(f"Ejecutando consulta para venta_id: {venta_id}")
            cursor.execute("SELECT obtener_datos_reporte_venta(%s);", [venta_id])
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print(f"No se encontró resultado en la BD para venta_id: {venta_id}")
                return HttpResponseNotFound(f'No se encontraron datos para la venta con ID {venta_id}')

            # El resultado es un diccionario de Python
            report_data = result[0]
            print("Datos obtenidos de la BD correctamente. Procediendo a serializar.")

            # Convertimos manualmente a JSON
            json_output = json.dumps(report_data, cls=DjangoJSONEncoder)
            
            print("Serialización a JSON exitosa. Enviando respuesta.")
            
            # Devolvemos una HttpResponse con el tipo de contenido correcto.
            return HttpResponse(json_output, content_type='application/json')

    except Exception as e:
        print(f"¡ERROR! Ocurrió una excepción en la vista: {e}")
        return JsonResponse({'success': False, 'error': str(e)}, status=500)
    

# Orden de Compra
@login_required
def vista_orden_compra(request):
    """Vista para mostrar el reporte de órdenes de compra"""
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado.')
        return redirect('login')
    
    return render(request, 'empleados/reportes/orden_compra_reporte.html')


def generar_orden_compra_api(request, orden_id):
    """API para generar datos de orden de compra"""
    if request.method != 'GET':
        return JsonResponse({'error': 'Método no permitido'}, status=405)

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT obtener_datos_orden_compra(%s);", [orden_id])
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                return HttpResponseNotFound(f'No se encontraron datos para la orden de compra con ID {orden_id}')

            report_data = result[0]
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)}, status=500)
    

# Reportes de Productores en Eventos
@login_required
def vista_reporte_productores(request):
    """Vista para mostrar el reporte de productores en eventos"""
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado.')
        return redirect('login')
    
    return render(request, 'empleados/reportes/productores_eventos.html')


def reporte_productores_eventos_api(request):
    """
    API endpoint que devuelve los datos para el reporte de productores en eventos.
    """
    print("Iniciando llamada al API de reporte de productores...")
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_datos_productores_eventos();")
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print("La consulta a la BD no devolvió resultados.")
                return JsonResponse([], safe=False)

            report_data = result[0]
            print("Datos obtenidos de la BD correctamente. Se procederá a enviar.")

            json_output = json.dumps(report_data, cls=DjangoJSONEncoder, indent=4)
            return HttpResponse(json_output, content_type='application/json')

    except Exception as e:
        print("\n¡Ocurrió un error grave en la vista del API!")
        print("------------------------------------------")
        print(f"Tipo de Excepción: {type(e).__name__}")
        print(f"Error: {e}")
        print("------------------------------------------\n")
        return JsonResponse({'error': f'Ocurrió un error en el servidor: {e}'}, status=500)


# Reporte de Eficiencia de Despacho
@login_required
def vista_reporte_eficiencia(request):
    """Vista para mostrar el reporte de eficiencia de despacho"""
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado.')
        return redirect('login')
    
    return render(request, 'empleados/reportes/eficiencia_despacho.html')


def reporte_eficiencia_despacho_api(request):
    """
    API endpoint que devuelve el tiempo promedio de despacho.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.calcular_eficiencia_despacho();")
            result = cursor.fetchone()
            print("Ejecutando consulta para calcular eficiencia de despacho...")
            print(f"Resultado de la consulta: {result}")
            if result is None or result[0] is None:
                return JsonResponse({'error': 'No se pudo calcular la eficiencia.'}, status=404)

            report_data = result[0]
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


# Reporte Histórico de Ofertas
@login_required
def vista_reporte_ofertas(request):
    """Vista para mostrar el reporte de histórico de ofertas"""
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado.')
        return redirect('login')
    
    return render(request, 'empleados/reportes/historico_ofertas.html')


def reporte_historico_ofertas_api(request):
    """
    API endpoint que devuelve las ofertas activas en un rango de fechas.
    """
    print("Iniciando llamada al API de histórico de ofertas...")
    try:
        fecha_inicio_str = request.GET.get('inicio', '1900-01-01')
        fecha_fin_str = request.GET.get('fin', datetime.now().strftime('%Y-%m-%d'))
        
        print(f"Buscando ofertas entre {fecha_inicio_str} y {fecha_fin_str}")

        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT public.obtener_historico_ofertas(%s::DATE, %s::DATE);",
                [fecha_inicio_str, fecha_fin_str]
            )
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print("La consulta a la BD no devolvió resultados.")
                return JsonResponse([], safe=False)

            report_data = result[0]
            print("Datos obtenidos de la BD correctamente. Enviando respuesta.")
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except Exception as e:
        print("\n¡Ocurrió un error grave en la vista del API de Ofertas!")
        print("-----------------------------------------------------")
        print(f"Tipo de Excepción: {type(e).__name__}")
        print(f"Error: {e}")
        print("-----------------------------------------------------\n")
        return JsonResponse({'error': f'Ocurrió un error en el servidor: {e}'}, status=500)


# Reporte de Incumplimiento de Horario
@login_required
def vista_reporte_incumplimiento(request):
    """Vista para mostrar el reporte de incumplimiento de horario"""
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado.')
        return redirect('login')
    
    return render(request, 'empleados/reportes/incumplimiento_horario.html')


def reporte_incumplimiento_horario_api(request):
    """
    API endpoint que devuelve los incumplimientos de horario en un rango de fechas.
    """
    try:
        fecha_inicio_str = request.GET.get('inicio')
        fecha_fin_str = request.GET.get('fin')
        
        if not fecha_inicio_str or not fecha_fin_str:
            return JsonResponse({'error': 'Fechas de inicio y fin son requeridas'}, status=400)
        
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT public.obtener_reporte_incumplimiento_horario(%s::DATE, %s::DATE);",
                [fecha_inicio_str, fecha_fin_str]
            )
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                return JsonResponse([], safe=False)

            report_data = result[0]
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except Exception as e:
        print(f"Error en API de incumplimiento: {e}")
        return JsonResponse({'error': str(e)}, status=500)


# Reporte de Órdenes de Compra Pendientes
@login_required
def vista_reporte_ordenes_pendientes(request):
    """Vista para mostrar el reporte de órdenes pendientes"""
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado.')
        return redirect('login')
    
    return render(request, 'empleados/reportes/ordenes_pendientes.html')


def reporte_ordenes_pendientes_api(request):
    """
    API endpoint que devuelve las órdenes de compra pendientes.
    """
    print("Iniciando llamada al API de órdenes pendientes...")
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_ordenes_compra_pendientes();")
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print("La consulta a la BD no devolvió resultados.")
                return JsonResponse([], safe=False)

            report_data = result[0]
            print("Datos obtenidos de la BD correctamente. Enviando respuesta.")
            return JsonResponse(report_data, encoder=DjangoJSONEncoder, safe=False)

    except Exception as e:
        print("\n¡Ocurrió un error grave en la vista del API de Órdenes Pendientes!")
        print("-----------------------------------------------------------")
        print(f"Tipo de Excepción: {type(e).__name__}")
        print(f"Error: {e}")
        traceback.print_exc()
        print("-----------------------------------------------------------\n")
        return JsonResponse({'error': f'Ocurrió un error en el servidor: {e}'}, status=500)

from store.models import privilegio, rol, rol_privilegio

@requiere_privilegio("crear_rol")
def crear_rol_view(request):
    if request.method == 'POST':
        nombre = request.POST.get('nombre')
        privilegios_seleccionados = request.POST.getlist('privilegios')

        # Crear el rol
        nuevo_rol = rol.objects.create(rol_nombre=nombre)

        # Asociar privilegios
        for nombre_priv in privilegios_seleccionados:
            try:
                priv = privilegio.objects.get(privilegio_nombre=nombre_priv)
                rol_privilegio.objects.create(fk_rol=nuevo_rol, fk_privilegio=priv)
            except privilegio.DoesNotExist:
                pass  # Ignora privilegios inválidos

        return redirect('empleados:dashboard')

    # Mostrar formulario
    return render(request, 'empleados/crear_rol.html', {'privilegios': privilegio.objects.all()})

@requiere_privilegio("asignar_rol")
def asignar_rol_view(request):
    if request.method == 'POST':
        form = AsignarRolForm(request.POST)
        if form.is_valid():
            usuario_obj = form.cleaned_data['usuario']
            rol_obj = form.cleaned_data['rol']
            usuario_obj.fk_rol = rol_obj
            usuario_obj.save()
            return redirect('empleados:dashboard')  # Redirige al dashboard u otra página
    else:
        form = AsignarRolForm()
    return render(request, 'empleados/asignar_rol_form.html', {'form': form})

@login_required
def gestion_usuarios_view(request):
    usuarios = usuario.objects.all().select_related('fk_rol', 'fk_cliente', 'fk_proveedor', 'fk_emp_car')
    return render(request, 'empleados/gestion_usuarios.html', {'usuarios': usuarios})

@requiere_privilegio("crear_privilegio")
@csrf_protect
def crear_privilegio_view(request):
    if request.method == 'POST':
        nombre = request.POST.get('nombre')
        if nombre:
            privilegio.objects.create(privilegio_nombre=nombre.strip().lower())
            messages.success(request, "Privilegio creado exitosamente.")
            return redirect('empleados:dashboard')
        else:
            messages.error(request, "El nombre no puede estar vacío.")
    
    return render(request, 'empleados/crear_privilegio.html')

@requiere_privilegio('crear_privilegio')  # Usa el privilegio correspondiente
def modificar_privilegio_view(request, id):
    if request.method == 'POST':
        nuevo_nombre = request.POST.get('nombre')
        with connection.cursor() as cursor:
            cursor.execute("SELECT modificar_privilegio(%s, %s);", [id, nuevo_nombre])
        return redirect('lista_privilegios')  # o a donde desees redirigir
    return render(request, 'empleados/modificar_privilegio.html', {'id': id})

def modificar_rol_view(request, rol_id):
    rol_actual = get_object_or_404(rol, pk=rol_id)
    privilegios = privilegio.objects.all()
    privilegios_seleccionados = rol_privilegio.objects.filter(fk_rol=rol_actual).values_list('fk_privilegio', flat=True)

    if request.method == 'POST':
        nuevo_nombre = request.POST.get('nombre').strip()
        nuevos_privilegios = request.POST.getlist('privilegios')

        # Actualizar nombre
        rol_actual.rol_nombre = nuevo_nombre
        rol_actual.save()

        # Actualizar privilegios (eliminamos todos y volvemos a insertar)
        rol_privilegio.objects.filter(fk_rol=rol_actual).delete()
        for priv_id in nuevos_privilegios:
            rol_privilegio.objects.create(fk_rol=rol_actual, fk_privilegio=priv_id)

        messages.success(request, "Rol actualizado exitosamente.")
        return redirect('nombre_de_la_vista_de_listado_de_roles')

    context = {
        'rol': rol_actual,
        'privilegios': privilegio.objects.all(),
        'privilegios_seleccionados': list(privilegios_seleccionados),
    }
    return render(request, 'empleados/modificar_rol.html', context)

@requiere_privilegio('modificar_rol')
def listar_roles_view(request):
    roles = rol.objects.all()
    privilegios = request.session.get('privilegios', [])  # ✅ obtener de la sesión
    return render(request, 'empleados/listar_roles.html', {
        'roles': roles,
        'privilegios': privilegios  # ✅ incluir en el contexto
    })

@requiere_privilegio('modificar_privilegio')
def listar_privilegios_view(request):
    privilegios_list = privilegio.objects.all()
    privilegios_usuario = request.session.get('privilegios', [])
    return render(request, 'empleados/listar_privilegios.html', {
        'privilegios_list': privilegios_list,
        'privilegios': privilegios_usuario
    })

@requiere_privilegio('eliminar_rol')
def eliminar_rol_view(request, id):
    if request.method == 'POST':
        rol_obj = get_object_or_404(rol, id=id)
        rol_obj.delete()
        messages.success(request, 'Rol eliminado correctamente.')
        return redirect('empleados:listar_roles')
    return HttpResponseForbidden("Método no permitido.")

@requiere_privilegio('eliminar_privilegio')
def eliminar_privilegio_view(request, id):
    if request.method == 'POST':
        privilegio_obj = get_object_or_404(privilegio, id=id)
        privilegio_obj.delete()
        messages.success(request, 'Privilegio eliminado correctamente.')
        return redirect('empleados:listar_privilegios')
    return HttpResponseForbidden("Método no permitido.")

@requiere_privilegio('asignar_privilegio')
def seleccionar_rol_para_privilegios_view(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT rol_id, rol_nombre FROM rol;")
        roles = cursor.fetchall()

    return render(request, 'empleados/seleccionar_rol_para_privilegios.html', {
        'roles': roles
    })

@requiere_privilegio('asignar_privilegio')
def asignar_privilegio_view(request, id):
    with connection.cursor() as cursor:
        cursor.execute("SELECT privilegio_id, privilegio_nombre FROM privilegio;")
        privilegios = cursor.fetchall()

        cursor.execute("SELECT fk_privilegio FROM rol_privilegio WHERE fk_rol = %s;", [id])
        privilegios_asignados = [row[0] for row in cursor.fetchall()]

    if request.method == 'POST':
        privilegios_seleccionados = request.POST.getlist('privilegios')  # ['1', '2', '5']
        privilegios_seleccionados = list(map(int, privilegios_seleccionados))  # convertir a enteros

        with connection.cursor() as cursor:
            # 1. Eliminar todos los privilegios actuales de ese rol
            cursor.execute("DELETE FROM rol_privilegio WHERE fk_rol = %s;", [id])

            # 2. Insertar los seleccionados
            for p_id in privilegios_seleccionados:
                cursor.execute("SELECT asignar_privilegio_a_rol(%s, %s);", [p_id, id])

        messages.success(request, 'Privilegios asignados correctamente.')
        return redirect('empleados:dashboard')

    return render(request, 'empleados/asignar_privilegio.html', {
        'rol_id': id,
        'privilegios': privilegios,
        'privilegios_asignados': privilegios_asignados,
    })
# GESTIÓN DE ÓRDENES DE COMPRA
@login_required
def vista_gestion_ordenes(request):
    """
    Renderiza la página de gestión de órdenes de compra. Pasa la lista de
    posibles estatus a la plantilla para llenar los dropdowns.
    """
    estatus_posibles = list(Estatus.objects.values('est_id', 'est_tipo_estatus'))
    context = {
        'estatus_posibles': estatus_posibles
    }
    return render(request, 'empleados/gestion_ordenes.html', context)

@login_required
@login_required
def gestion_ordenes_api(request):
    """
    API endpoint que devuelve la lista completa de órdenes de compra.
    """
    print("Iniciando llamada al API de gestión de órdenes...")
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_todas_ordenes_compra();")
            result = cursor.fetchone()
            
            if result is None or result[0] is None:
                print("La consulta a la BD no devolvió resultados.")
                return JsonResponse([], safe=False)

            data = result[0]
            print("Datos obtenidos de la BD correctamente. Enviando respuesta.")
            return JsonResponse(data, safe=False)
            
    except Exception as e:
        print("\n¡Ocurrió un error grave en la vista del API de Gestión de Órdenes!")
        print("-----------------------------------------------------------------")
        print(f"Tipo de Excepción: {type(e).__name__}")
        print(f"Error: {e}")
        traceback.print_exc()
        print("-----------------------------------------------------------------\n")
        return JsonResponse({'error': f'Ocurrió un error en el servidor: {e}'}, status=500)


@csrf_exempt # Usar con precaución. Idealmente, configurarías CSRF con AJAX.
@login_required
def actualizar_orden_api(request, orden_id):
    """
    API endpoint para actualizar el estado de una orden de compra.
    """
    if request.method == 'POST':
        try:
            nuevo_estatus_id = request.POST.get('nuevo_estatus_id')
            if not nuevo_estatus_id:
                return JsonResponse({'success': False, 'error': 'Falta el ID del nuevo estatus.'}, status=400)

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT public.actualizar_estatus_orden_compra(%s, %s);",
                    [orden_id, nuevo_estatus_id]
                )
            return JsonResponse({'success': True, 'message': 'Estatus actualizado correctamente.'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

def vista_orden_compra_directa(request, orden_id):
    """
    Renderiza el reporte de una orden de compra específica, obteniendo los datos
    directamente desde la base de datos y pasándolos a la plantilla.
    """
    try:
        with connection.cursor() as cursor:
            # 1. Llama a la función SQL que ya creamos para obtener los datos
            cursor.execute("SELECT public.obtener_datos_orden_compra(%s);", [orden_id])
            result = cursor.fetchone()

            if result is None or result[0] is None:
                return HttpResponseNotFound("<h1>Orden de Compra no encontrada</h1><p>No se encontraron datos para la orden especificada.</p>")

            # 2. Los datos vienen en formato JSON desde la base de datos
            report_data = result[0]
            
            # 3. Se pasan los datos a la plantilla en un contexto.
            context = {
                'report_data': report_data
            }
            
            # 4. Renderiza la nueva plantilla de orden de compra
            return render(request, 'empleados/orden_template.html', context)

    except Exception as e:
        # Manejo de errores
        print(f"Error al generar la orden de compra directa: {e}")
        return HttpResponse(f"<h1>Error al generar la orden</h1><p>{e}</p>", status=500)
    

@login_required
def vista_gestion_reposicion(request):
    """
    Renderiza la página de gestión de solicitudes de reposición.
    """
    # Esta línea ahora funcionará porque el modelo 'Estatus' ha sido importado.
    estatus_posibles = list(Estatus.objects.values('est_id', 'est_tipo_estatus'))
    
    context = {
        'estatus_posibles': estatus_posibles
    }
    return render(request, 'empleados/gestion_reposicion.html', context)

@login_required
def gestion_reposicion_api(request):
    """
    API endpoint que devuelve la lista completa de solicitudes de reposición.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_todas_solicitudes_reposicion();")
            result = cursor.fetchone()
            data = result[0] if result and result[0] is not None else []
            return JsonResponse(data, safe=False)
    except Exception as e:
        # Para depuración
        import traceback
        print("Error en gestion_reposicion_api:", e)
        traceback.print_exc()
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@login_required
def actualizar_reposicion_api(request, solicitud_id):
    """
    API endpoint para actualizar el estado de una solicitud de reposición.
    """
    if request.method == 'POST':
        try:
            nuevo_estatus_id = request.POST.get('nuevo_estatus_id')
            if not nuevo_estatus_id:
                return JsonResponse({'success': False, 'error': 'Falta el ID del nuevo estatus.'}, status=400)

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT public.actualizar_estatus_solicitud_reposicion(%s, %s);",
                    [solicitud_id, nuevo_estatus_id]
                )
            return JsonResponse({'success': True, 'message': 'Estatus actualizado correctamente.'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

# ========== GESTIÓN DE SOLICITUDES PENDIENTES ==========

@login_required
def vista_gestion_solicitudes_pendientes(request):
    """
    Vista para gestionar específicamente las solicitudes de compra pendientes.
    Permite cambiar proveedor y aprobar solicitudes.
    """
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado.')
        return redirect('login')
    
    return render(request, 'empleados/gestion_solicitudes_pendientes.html')

@login_required
def solicitudes_pendientes_api(request):
    """
    API endpoint que devuelve las solicitudes de compra pendientes con información detallada.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_ordenes_compra_pendientes();")
            result = cursor.fetchone()
            data = result[0] if result and result[0] is not None else []
            return JsonResponse(data, safe=False)
    except Exception as e:
        print(f"Error en solicitudes_pendientes_api: {e}")
        return JsonResponse({'error': str(e)}, status=500)

@login_required
def proveedores_api(request):
    """
    API endpoint que devuelve la lista de todos los proveedores.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_proveedores();")
            result = cursor.fetchone()
            data = result[0] if result and result[0] is not None else []
            return JsonResponse(data, safe=False)
    except Exception as e:
        print(f"Error en proveedores_api: {e}")
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@login_required
def cambiar_proveedor_api(request, solicitud_id):
    """
    API endpoint para cambiar el proveedor de una solicitud de compra.
    """
    if request.method == 'POST':
        try:
            nuevo_proveedor_id = request.POST.get('nuevo_proveedor_id')
            if not nuevo_proveedor_id:
                return JsonResponse({'success': False, 'error': 'Falta el ID del nuevo proveedor.'}, status=400)

            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT public.cambiar_proveedor_solicitud(%s, %s);",
                    [solicitud_id, nuevo_proveedor_id]
                )
            return JsonResponse({'success': True, 'message': 'Proveedor actualizado correctamente.'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@csrf_exempt
@login_required
def aprobar_solicitud_api(request, solicitud_id):
    """
    API endpoint para aprobar una solicitud de compra (cambiar estatus a APROBADO).
    """
    if request.method == 'POST':
        try:
            # Obtener el usuario actual que está aprobando
            usuario_aprobador_id = request.user.id
            
            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT public.aprobar_solicitud_compra(%s, %s);",
                    [solicitud_id, usuario_aprobador_id]
                )
            return JsonResponse({'success': True, 'message': 'Solicitud aprobada correctamente.'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@login_required
def solicitudes_aprobadas_api(request):
    """
    API endpoint que devuelve las solicitudes de compra aprobadas.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_solicitudes_aprobadas();")
            result = cursor.fetchone()
            data = result[0] if result and result[0] is not None else []
            return JsonResponse(data, safe=False)
    except Exception as e:
        print(f"Error en solicitudes_aprobadas_api: {e}")
        return JsonResponse({'error': str(e)}, status=500)

@login_required
def solicitudes_rechazadas_api(request):
    """
    API endpoint que devuelve las solicitudes de compra rechazadas.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_solicitudes_rechazadas();")
            result = cursor.fetchone()
            data = result[0] if result and result[0] is not None else []
            return JsonResponse(data, safe=False)
    except Exception as e:
        print(f"Error en solicitudes_rechazadas_api: {e}")
        return JsonResponse({'error': str(e)}, status=500)

@login_required
def solicitudes_entregadas_api(request):
    """
    API endpoint que devuelve las solicitudes de compra entregadas con paginación.
    """
    try:
        limite = int(request.GET.get('limite', 20))
        pagina = int(request.GET.get('pagina', 1))
        offset = (pagina - 1) * limite
        
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.obtener_solicitudes_entregadas(%s, %s);", [limite, offset])
            result = cursor.fetchone()
            data = result[0] if result and result[0] is not None else {'solicitudes': [], 'total_count': 0}
            return JsonResponse(data, safe=False)
    except Exception as e:
        print(f"Error en solicitudes_entregadas_api: {e}")
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@login_required
def rechazar_solicitud_api(request, solicitud_id):
    """
    API endpoint para rechazar una solicitud de compra.
    """
    if request.method == 'POST':
        try:
            usuario_rechaza_id = request.user.id
            
            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT public.rechazar_solicitud_compra(%s, %s);",
                    [solicitud_id, usuario_rechaza_id]
                )
            return JsonResponse({'success': True, 'message': 'Solicitud rechazada correctamente.'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@csrf_exempt
@login_required
def devolver_a_pendiente_api(request, solicitud_id):
    """
    API endpoint para devolver una solicitud rechazada a pendiente.
    """
    if request.method == 'POST':
        try:
            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT public.devolver_solicitud_a_pendiente(%s);",
                    [solicitud_id]
                )
            return JsonResponse({'success': True, 'message': 'Solicitud devuelta a pendiente correctamente.'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@csrf_exempt
@login_required
def marcar_entregada_api(request, solicitud_id):
    """
    API endpoint para marcar una solicitud como entregada.
    """
    if request.method == 'POST':
        try:
            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT public.marcar_solicitud_entregada(%s);",
                    [solicitud_id]
                )
            return JsonResponse({'success': True, 'message': 'Solicitud marcada como entregada correctamente.'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método no permitido'}, status=405)