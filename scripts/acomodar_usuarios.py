from django.contrib.auth import get_user_model
from django.utils.timezone import now
from datetime import datetime

User = get_user_model()

usuarios = [
    ("admin001", "admin001", "admin@acaucab.com", True, None, None),
    ("gerente_maria", "maria456", "maria.gonzalez@acaucab.com", True, None, None),
    ("almacen_jose", "jose789", "jose.rodriguez@acaucab.com", True, None, None),
    ("marketing_ana", "ana012", "ana.fernandez@acaucab.com", True, None, None),
    ("logistica_luis", "luis345", "luis.torres@acaucab.com", True, None, None),
    ("ventas_carmen", "carmen678", "carmen.herrera@acaucab.com", True, None, None),
    ("vendedor_ricardo", "ricardo901", "ricardo.mendoza@acaucab.com", True, None, None),
    ("cerveza_patricia", "patricia234", "patricia.suarez@acaucab.com", True, None, None),
    ("admin_fernando", "fernando567", "fernando.delgado@acaucab.com", True, None, None),
    ("caja_gabriela", "gabriela890", "gabriela.vega@acaucab.com", True, None, None),
    # Clientes
    *[(f"cliente_{n}", "pass123", f"{n}@email.com", False, i, None)
      for i, n in enumerate(["carlos", "maria", "jose", "ana", "luis", "carmen", "pedro", "rosa", "miguel", "luisa",
                             "roberto", "elena", "jorge", "patricia", "fernando", "gabriela", "andres", "beatriz",
                             "ricardo", "maritza"], start=1)],
    # Proveedores
    ("prov_maltas", "malta123", "ventas@maltasandinas.com", False, None, 1),
    ("prov_lupulos", "lupulo456", "comercial@lupuloscaribe.com", False, None, 2),
    ("prov_levaduras", "levadura789", "info@levadurasgourmet.com", False, None, 3),
    ("prov_envases", "envase012", "pedidos@envasespremium.com", False, None, 4),
    ("prov_tecnologia", "tech345", "soporte@beertech.com", False, None, 5),
]

for username, raw_password, email, is_superuser, fk_cliente, fk_proveedor in usuarios:
    user, created = User.objects.get_or_create(username=username)
    user.set_password(raw_password)
    user.email = email
    user.is_active = True
    user.is_staff = True
    user.is_superuser = is_superuser
    user.date_joined = now()

    # Solo si tu modelo tiene estos campos:
    if hasattr(user, 'fk_cliente'):
        user.fk_cliente_id = fk_cliente
    if hasattr(user, 'fk_proveedor'):
        user.fk_proveedor_id = fk_proveedor

    user.save()
    print(f"{'Creado' if created else 'Actualizado'}: {username}")