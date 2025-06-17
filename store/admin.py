from django.contrib import admin
from .models import *

# Register your models here.

admin.site.register(Customer)
admin.site.register(Product)
admin.site.register(Order)
admin.site.register(OrderItem)
admin.site.register(ShippingAddress)

@admin.register(Promotion)
class PromotionAdmin(admin.ModelAdmin):
    list_display = ['name', 'discount_type', 'discount_amount', 'status', 'start_date', 'end_date', 'is_active']
    list_filter = ['status', 'discount_type', 'start_date', 'end_date']
    search_fields = ['name']
    filter_horizontal = ['products']
    
    fieldsets = (
        ('Información básica', {
            'fields': ('name', 'discount_type', 'discount_amount', 'status')
        }),
        ('Fechas', {
            'fields': ('start_date', 'end_date')
        }),
        ('Productos', {
            'fields': ('products',)
        }),
    )