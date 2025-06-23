from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model
from .models import cliente, proveedor

User = get_user_model()

class CustomUserCreationForm(UserCreationForm):
    first_name = forms.CharField(
        required=True,
        label='Nombre',
        max_length=150
    )
    last_name = forms.CharField(
        required=True,
        label='Apellido',
        max_length=150
    )
    fk_cliente = forms.ModelChoiceField(
        queryset=cliente.objects.all(),
        required=False,
        label='Cliente'
    )
    fk_proveedor = forms.ModelChoiceField(
        queryset=proveedor.objects.all(),
        required=False,
        label='Proveedor'
    )

    class Meta:
        model = User
        fields = (
            'username', 'email', 'password1', 'password2',
            'first_name', 'last_name', 'fk_cliente', 'fk_proveedor'
        )