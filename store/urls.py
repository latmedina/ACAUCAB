from django.urls import path
from . import views

urlpatterns = [
    path('', views.store, name = 'store'),
    path('cart/', views.cart, name = 'cart'),
    path('checkout/', views.checkout, name = 'checkout'),
    path('update_item/', views.updateItem, name='update_item'),
    path('process_order/', views.processOrder, name='process_order'),
    
    # URLs para promociones
    path('promotions/', views.promotions, name='promotions'),
    path('promotions/api/list/', views.promotions_list_api, name='promotions_list_api'),
    path('promotions/api/detail/<int:promotion_id>/', views.promotion_detail_api, name='promotion_detail_api'),
    path('promotions/api/products/', views.products_api, name='products_api'),
    path('promotions/api/create/', views.create_promotion_api, name='create_promotion_api'),
    path('promotions/api/update/<int:promotion_id>/', views.update_promotion_api, name='update_promotion_api'),
]
