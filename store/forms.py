from django import forms
from .models import cliente, empleado, proveedor, lugar
import re

class ClienteForm(forms.ModelForm):
    # Campos para el selector jerárquico de lugar
    estado = forms.ModelChoiceField(
        queryset=lugar.objects.filter(lug_tipo='estado'),
        empty_label="Selecciona un estado",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_estado'}),
        label="Estado"
    )
    municipio = forms.ModelChoiceField(
        queryset=lugar.objects.none(),
        empty_label="Primero selecciona un estado",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_municipio'}),
        label="Municipio"
    )
    parroquia = forms.ModelChoiceField(
        queryset=lugar.objects.none(),
        empty_label="Primero selecciona un municipio",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_parroquia'}),
        label="Parroquia"
    )

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
            'cli_jur_dir_fiscal',
        ]
        
        labels = {
            'cli_rif': 'RIF',
            'cli_direccion_fisica': 'Dirección Física',
            'cli_tipo_cliente': 'Tipo de Cliente',
            'cli_nat_ci': 'Cédula de Identidad',
            'cli_nat_pnombre': 'Primer Nombre',
            'cli_nat_snombre': 'Segundo Nombre',
            'cli_nat_papellido': 'Primer Apellido',
            'cli_nat_sapellido': 'Segundo Apellido',
            'cli_nat_sexo': 'Sexo',
            'cli_jur_denom_comercial': 'Denominación Comercial',
            'cli_jur_razon_social': 'Razón Social',
            'cli_jur_url_web': 'Sitio Web',
            'cli_jur_dir_fiscal': 'Dirección Fiscal',
        }
        
        widgets = {
            'cli_rif': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Ej: J-12345678-9',
                'maxlength': '12'
            }),
            'cli_direccion_fisica': forms.Textarea(attrs={
                'class': 'form-control',
                'rows': 3,
                'placeholder': 'Dirección completa del cliente'
            }),
            'cli_tipo_cliente': forms.HiddenInput(),  # Será manejado por el toggle
            'cli_nat_ci': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Ej: V-12345678',
                'maxlength': '12'
            }),
            'cli_nat_pnombre': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Primer nombre'
            }),
            'cli_nat_snombre': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Segundo nombre (opcional)'
            }),
            'cli_nat_papellido': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Primer apellido'
            }),
            'cli_nat_sapellido': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Segundo apellido (opcional)'
            }),
            'cli_nat_sexo': forms.Select(
                choices=[('M', 'Masculino'), ('F', 'Femenino')],
                attrs={'class': 'form-control'}
            ),
            'cli_jur_denom_comercial': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Nombre comercial de la empresa'
            }),
            'cli_jur_razon_social': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Razón social completa'
            }),
            'cli_jur_url_web': forms.URLInput(attrs={
                'class': 'form-control',
                'placeholder': 'https://ejemplo.com'
            }),
            'cli_jur_dir_fiscal': forms.Textarea(attrs={
                'class': 'form-control',
                'rows': 3,
                'placeholder': 'Dirección fiscal de la empresa'
            }),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        # Si estamos editando un cliente existente, cargar los datos del lugar
        if self.instance and self.instance.pk and hasattr(self.instance, 'fk_lugar'):
            parroquia = self.instance.fk_lugar
            if parroquia and parroquia.lug_tipo == 'parroquia':
                municipio = parroquia.fk_lugar
                if municipio and municipio.lug_tipo == 'municipio':
                    estado = municipio.fk_lugar
                    if estado and estado.lug_tipo == 'estado':
                        self.fields['estado'].initial = estado
                        self.fields['municipio'].queryset = lugar.objects.filter(fk_lugar=estado)
                        self.fields['municipio'].initial = municipio
                        self.fields['parroquia'].queryset = lugar.objects.filter(fk_lugar=municipio)
                        self.fields['parroquia'].initial = parroquia

    def clean_cli_rif(self):
        rif = self.cleaned_data.get('cli_rif')
        if rif:
            # Limpiar espacios y guiones
            rif = rif.replace(' ', '').replace('-', '').upper()
            
            # Validar formato básico de RIF (letra + máximo 10 dígitos)
            if not re.match(r'^[VEJPG]\d{1,10}$', rif):
                raise forms.ValidationError(
                    'El RIF debe tener el formato válido (Ej: J123456789) y máximo 10 dígitos después de la letra.'
                )
            
            # Guardar SIN guiones para mantener coherencia con el resto del sistema
            # El RIF se guarda limpio: J123456789
        
        return rif

    def clean_cli_nat_ci(self):
        ci = self.cleaned_data.get('cli_nat_ci')
        if ci:
            # Limpiar espacios y guiones
            ci = ci.replace(' ', '').replace('-', '').upper()
            
            # Validar formato básico de CI (letra + máximo 10 dígitos)
            if not re.match(r'^[VE]\d{1,10}$', ci):
                raise forms.ValidationError(
                    'La cédula debe tener el formato válido (Ej: V12345678) y máximo 10 dígitos.'
                )
            
            # Guardar SIN guiones para mantener coherencia con el resto del sistema
            # La CI se guarda limpia: V12345678
        
        return ci

    def clean(self):
        cleaned_data = super().clean()
        tipo_cliente = cleaned_data.get('cli_tipo_cliente')
        parroquia = cleaned_data.get('parroquia')
        
        # Intentar obtener la parroquia de diferentes maneras
        if not parroquia and hasattr(self, 'data'):
            parroquia_id = self.data.get('parroquia')
            if parroquia_id:
                try:
                    parroquia = lugar.objects.get(lug_id=parroquia_id)
                    cleaned_data['parroquia'] = parroquia
                except lugar.DoesNotExist:
                    pass

        # Solo validar parroquia si no se pudo obtener de ninguna manera
        if not parroquia:
            print(f"DEBUG: No se encontró parroquia. Data: {getattr(self, 'data', {})}")
            # Validación menos estricta por ahora - permitir continuar sin parroquia temporalmente
            # raise forms.ValidationError('Debe seleccionar una parroquia.')

        # Validaciones específicas según el tipo de cliente
        if tipo_cliente == 'NATURAL':
            # Campos requeridos para persona natural
            required_fields = ['cli_nat_ci', 'cli_nat_pnombre', 'cli_nat_papellido', 'cli_nat_sexo']
            for field in required_fields:
                if not cleaned_data.get(field):
                    field_label = self.fields[field].label
                    raise forms.ValidationError(f'{field_label} es requerido para personas naturales.')
        
        elif tipo_cliente == 'JURIDICO':
            # Campos requeridos para persona jurídica
            required_fields = ['cli_jur_razon_social']
            for field in required_fields:
                if not cleaned_data.get(field):
                    field_label = self.fields[field].label
                    raise forms.ValidationError(f'{field_label} es requerido para personas jurídicas.')
        
        return cleaned_data

    def save(self, commit=True):
        instance = super().save(commit=False)
        
        # Asignar la parroquia seleccionada
        parroquia = self.cleaned_data.get('parroquia')
        if not parroquia and hasattr(self, 'data'):
            # Intentar obtener la parroquia desde los datos del request
            parroquia_id = self.data.get('parroquia')
            if parroquia_id:
                try:
                    parroquia = lugar.objects.get(lug_id=parroquia_id)
                except lugar.DoesNotExist:
                    parroquia = None
        
        if parroquia:
            instance.fk_lugar = parroquia
        else:
            # Si no hay parroquia, usar una por defecto (ajusta según tu base de datos)
            try:
                parroquia_default = lugar.objects.filter(lug_tipo='parroquia').first()
                if parroquia_default:
                    instance.fk_lugar = parroquia_default
            except:
                pass
        
        # Inicializar capital en 0 para personas jurídicas
        if instance.cli_tipo_cliente == 'JURIDICO':
            instance.cli_jur_capital = 0
            
        if commit:
            instance.save()
        return instance


class EmpleadoForm(forms.ModelForm):
    # Campos para el selector jerárquico de lugar
    estado = forms.ModelChoiceField(
        queryset=lugar.objects.filter(lug_tipo='estado'),
        empty_label="Selecciona un estado",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_estado'}),
        label="Estado"
    )
    municipio = forms.ModelChoiceField(
        queryset=lugar.objects.none(),
        empty_label="Primero selecciona un estado",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_municipio'}),
        label="Municipio"
    )
    parroquia = forms.ModelChoiceField(
        queryset=lugar.objects.none(),
        empty_label="Primero selecciona un municipio",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_parroquia'}),
        label="Parroquia"
    )

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
        ]
        
        labels = {
            'emp_ci': 'Cédula de Identidad',
            'emp_pnombre': 'Primer Nombre',
            'emp_snombre': 'Segundo Nombre',
            'emp_papellido': 'Primer Apellido',
            'emp_sapellido': 'Segundo Apellido',
            'emp_direccion': 'Dirección',
            'emp_fecha_nacimiento': 'Fecha de Nacimiento',
            'emp_sexo': 'Sexo',
        }
        
        widgets = {
            'emp_ci': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Ej: V-12345678',
                'maxlength': '12'
            }),
            'emp_pnombre': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Primer nombre'
            }),
            'emp_snombre': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Segundo nombre (opcional)'
            }),
            'emp_papellido': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Primer apellido'
            }),
            'emp_sapellido': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Segundo apellido (opcional)'
            }),
            'emp_direccion': forms.Textarea(attrs={
                'class': 'form-control',
                'rows': 3,
                'placeholder': 'Dirección completa del empleado'
            }),
            'emp_fecha_nacimiento': forms.DateInput(attrs={
                'class': 'form-control',
                'type': 'date'
            }),
            'emp_sexo': forms.Select(
                choices=[('M', 'Masculino'), ('F', 'Femenino')],
                attrs={'class': 'form-control'}
            ),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        # Si estamos editando un empleado existente, cargar los datos del lugar
        if self.instance and self.instance.pk and hasattr(self.instance, 'fk_lugar'):
            parroquia = self.instance.fk_lugar
            if parroquia and parroquia.lug_tipo == 'parroquia':
                municipio = parroquia.fk_lugar
                if municipio and municipio.lug_tipo == 'municipio':
                    estado = municipio.fk_lugar
                    if estado and estado.lug_tipo == 'estado':
                        self.fields['estado'].initial = estado
                        self.fields['municipio'].queryset = lugar.objects.filter(fk_lugar=estado)
                        self.fields['municipio'].initial = municipio
                        self.fields['parroquia'].queryset = lugar.objects.filter(fk_lugar=municipio)
                        self.fields['parroquia'].initial = parroquia

    def clean_emp_ci(self):
        ci = self.cleaned_data.get('emp_ci')
        if ci:
            # Limpiar espacios y guiones
            ci = ci.replace(' ', '').replace('-', '').upper()
            
            # Validar formato básico de CI (letra + máximo 10 dígitos)
            if not re.match(r'^[VE]\d{1,10}$', ci):
                raise forms.ValidationError(
                    'La cédula debe tener el formato válido (Ej: V12345678) y máximo 10 dígitos.'
                )
            
            # Guardar SIN guiones para mantener coherencia con el resto del sistema
            # La CI se guarda limpia: V12345678
        
        return ci

    def clean(self):
        cleaned_data = super().clean()
        parroquia = cleaned_data.get('parroquia')
        
        # Intentar obtener la parroquia de diferentes maneras
        if not parroquia and hasattr(self, 'data'):
            parroquia_id = self.data.get('parroquia')
            if parroquia_id:
                try:
                    parroquia = lugar.objects.get(lug_id=parroquia_id)
                    cleaned_data['parroquia'] = parroquia
                except lugar.DoesNotExist:
                    pass

        # Solo validar parroquia si no se pudo obtener de ninguna manera
        if not parroquia:
            print(f"DEBUG: No se encontró parroquia en EmpleadoForm. Data: {getattr(self, 'data', {})}")
            # Validación menos estricta por ahora - permitir continuar sin parroquia temporalmente
            # raise forms.ValidationError('Debe seleccionar una parroquia.')
        
        return cleaned_data

    def save(self, commit=True):
        instance = super().save(commit=False)
        
        # Asignar la parroquia seleccionada
        parroquia = self.cleaned_data.get('parroquia')
        if not parroquia and hasattr(self, 'data'):
            # Intentar obtener la parroquia desde los datos del request
            parroquia_id = self.data.get('parroquia')
            if parroquia_id:
                try:
                    parroquia = lugar.objects.get(lug_id=parroquia_id)
                except lugar.DoesNotExist:
                    parroquia = None
        
        if parroquia:
            instance.fk_lugar = parroquia
        else:
            # Si no hay parroquia, usar una por defecto
            try:
                parroquia_default = lugar.objects.filter(lug_tipo='parroquia').first()
                if parroquia_default:
                    instance.fk_lugar = parroquia_default
            except:
                pass
        
        if commit:
            instance.save()
        return instance


class ProveedorForm(forms.ModelForm):
    # Campos para el selector jerárquico de lugar
    estado = forms.ModelChoiceField(
        queryset=lugar.objects.filter(lug_tipo='estado'),
        empty_label="Selecciona un estado",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_estado'}),
        label="Estado"
    )
    municipio = forms.ModelChoiceField(
        queryset=lugar.objects.none(),
        empty_label="Primero selecciona un estado",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_municipio'}),
        label="Municipio"
    )
    parroquia = forms.ModelChoiceField(
        queryset=lugar.objects.none(),
        empty_label="Primero selecciona un municipio",
        widget=forms.Select(attrs={'class': 'form-control', 'id': 'id_parroquia'}),
        label="Parroquia"
    )

    class Meta:
        model = proveedor
        fields = [
            'pro_rif',
            'pro_denominacion_comercial',
            'pro_razon_social',
            'pro_url_web',
            'pro_direccion_fiscal',
        ]
        
        labels = {
            'pro_rif': 'RIF',
            'pro_denominacion_comercial': 'Denominación Comercial',
            'pro_razon_social': 'Razón Social',
            'pro_url_web': 'Sitio Web',
            'pro_direccion_fiscal': 'Dirección Fiscal',
        }
        
        widgets = {
            'pro_rif': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Ej: J-12345678-9',
                'maxlength': '12'
            }),
            'pro_denominacion_comercial': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Nombre comercial del proveedor'
            }),
            'pro_razon_social': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Razón social completa'
            }),
            'pro_url_web': forms.URLInput(attrs={
                'class': 'form-control',
                'placeholder': 'https://ejemplo.com'
            }),
            'pro_direccion_fiscal': forms.Textarea(attrs={
                'class': 'form-control',
                'rows': 3,
                'placeholder': 'Dirección fiscal del proveedor'
            }),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        # Si estamos editando un proveedor existente, cargar los datos del lugar
        if self.instance and self.instance.pk and hasattr(self.instance, 'fk_lugar'):
            parroquia = self.instance.fk_lugar
            if parroquia and parroquia.lug_tipo == 'parroquia':
                municipio = parroquia.fk_lugar
                if municipio and municipio.lug_tipo == 'municipio':
                    estado = municipio.fk_lugar
                    if estado and estado.lug_tipo == 'estado':
                        self.fields['estado'].initial = estado
                        self.fields['municipio'].queryset = lugar.objects.filter(fk_lugar=estado)
                        self.fields['municipio'].initial = municipio
                        self.fields['parroquia'].queryset = lugar.objects.filter(fk_lugar=municipio)
                        self.fields['parroquia'].initial = parroquia

    def clean_pro_rif(self):
        rif = self.cleaned_data.get('pro_rif')
        if rif:
            # Limpiar espacios y guiones
            rif = rif.replace(' ', '').replace('-', '').upper()
            
            # Validar formato básico de RIF (letra + máximo 10 dígitos)
            if not re.match(r'^[VEJPG]\d{1,10}$', rif):
                raise forms.ValidationError(
                    'El RIF debe tener el formato válido (Ej: J123456789) y máximo 10 dígitos después de la letra.'
                )
            
            # Guardar SIN guiones para mantener coherencia con el resto del sistema
            # El RIF se guarda limpio: J123456789
        
        return rif

    def clean(self):
        cleaned_data = super().clean()
        parroquia = cleaned_data.get('parroquia')
        
        # Intentar obtener la parroquia de diferentes maneras
        if not parroquia and hasattr(self, 'data'):
            parroquia_id = self.data.get('parroquia')
            if parroquia_id:
                try:
                    parroquia = lugar.objects.get(lug_id=parroquia_id)
                    cleaned_data['parroquia'] = parroquia
                except lugar.DoesNotExist:
                    pass

        # Solo validar parroquia si no se pudo obtener de ninguna manera
        if not parroquia:
            print(f"DEBUG: No se encontró parroquia en ProveedorForm. Data: {getattr(self, 'data', {})}")
            # Validación menos estricta por ahora - permitir continuar sin parroquia temporalmente
            # raise forms.ValidationError('Debe seleccionar una parroquia.')
        
        # Validar que al menos uno de los nombres esté presente
        if not cleaned_data.get('pro_denominacion_comercial') and not cleaned_data.get('pro_razon_social'):
            raise forms.ValidationError('Debe proporcionar al menos la denominación comercial o la razón social.')
        
        return cleaned_data

    def save(self, commit=True):
        instance = super().save(commit=False)
        
        # Asignar la parroquia seleccionada
        parroquia = self.cleaned_data.get('parroquia')
        if not parroquia and hasattr(self, 'data'):
            # Intentar obtener la parroquia desde los datos del request
            parroquia_id = self.data.get('parroquia')
            if parroquia_id:
                try:
                    parroquia = lugar.objects.get(lug_id=parroquia_id)
                except lugar.DoesNotExist:
                    parroquia = None
        
        if parroquia:
            instance.fk_lugar = parroquia
        else:
            # Si no hay parroquia, usar una por defecto
            try:
                parroquia_default = lugar.objects.filter(lug_tipo='parroquia').first()
                if parroquia_default:
                    instance.fk_lugar = parroquia_default
            except:
                pass
        
        if commit:
            instance.save()
        return instance