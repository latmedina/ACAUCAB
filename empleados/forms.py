from django import forms
import re
from store.models import usuario, rol

class AsignarRolForm(forms.Form):
    usuario = forms.ModelChoiceField(
        queryset=usuario.objects.all(),
        label="Usuario",
        widget=forms.Select(attrs={'class': 'form-control'})
    )
    rol = forms.ModelChoiceField(
        queryset=rol.objects.all(),
        label="Rol",
        widget=forms.Select(attrs={'class': 'form-control'})
    )