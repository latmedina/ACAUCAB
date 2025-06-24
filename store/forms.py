from django import forms
from .models import cliente, empleado, proveedor

class ClienteForm(forms.ModelForm):
    class Meta:
        model = cliente
        fields = [
            'cli_rif',
            'cli_direccion_fisica',
            'cli_tipo_cliente',
            'cli_nat_ci',
            'cli_nat_pnombre',
            'cli_nat_snombre',
            'cli_nat_papellido',
            'cli_nat_sapellido',
            'cli_nat_sexo',
            'cli_jur_denom_comercial',
            'cli_jur_razon_social',
            'cli_jur_url_web',
            'cli_jur_capital',
            'cli_jur_dir_fiscal',
            'fk_lugar',
        ]
        widgets = {
            'cli_tipo_cliente': forms.Select(choices=[('NATURAL', 'Natural'), ('JURIDICO', 'Jurídico')]),
        }

class EmpleadoForm(forms.ModelForm):
    class Meta:
        model = empleado
        fields = [
            'emp_ci',
            'emp_pnombre',
            'emp_snombre',
            'emp_papellido',
            'emp_sapellido',
            'emp_direccion',
            'emp_fecha_nacimiento',
            'emp_sexo',
            'fk_lugar',
        ]
        widgets = {
            'emp_fecha_nacimiento': forms.DateInput(attrs={'type': 'date'}),
            'emp_sexo': forms.Select(choices=[('M', 'Masculino'), ('F', 'Femenino')]),
        }

class ProveedorForm(forms.ModelForm):
    class Meta:
        model = proveedor
        fields = [
            'pro_rif',
            'pro_denominacion_comercial',
            'pro_razon_social',
            'pro_url_web',
            'pro_direccion_fiscal',
            'fk_lugar',
        ]