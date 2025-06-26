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

from store.models import estatus as Estatus


@login_required
def empleado_dashboard(request):
    """
    Dashboard principal para empleados.
    """
    # Verificar que el usuario es un empleado
    if not hasattr(request.user, 'fk_emp_car') or not request.user.fk_emp_car:
        messages.error(request, 'Acceso denegado. Solo empleados pueden acceder a este módulo.')
        return redirect('login')
    
    # Obtener el empleado a través de emp_car
    empleado = request.user.fk_emp_car.fk_empleado
    
    context = {
        'empleado': empleado,
        'usuario': request.user,
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