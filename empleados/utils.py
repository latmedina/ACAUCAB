from store.models import privilegio
from django.http import HttpResponseForbidden

from functools import wraps

def obtener_privilegios(usuario):
    if usuario.fk_rol:
        return privilegio.objects.filter(
            rol_privilegio__fk_rol=usuario.fk_rol
        ).values_list('privilegio_nombre', flat=True)
    return []

def requiere_privilegio(nombre_privilegio):
    def decorador(view_func):
        @wraps(view_func)  # ✅ ESTO ES CRUCIAL
        def wrapper(request, *args, **kwargs):
            if request.user.is_authenticated:
                rol_usuario = getattr(request.user, 'fk_rol', None)

                # Permitir acceso total al ADMINISTRADOR
                if rol_usuario and rol_usuario.rol_nombre.strip().upper() == "ADMINISTRADOR":
                    return view_func(request, *args, **kwargs)

                privilegios = obtener_privilegios(request.user)
                if nombre_privilegio in privilegios:
                    return view_func(request, *args, **kwargs)
            return HttpResponseForbidden("No tienes permiso para esta acción.")
        return wrapper
    return decorador