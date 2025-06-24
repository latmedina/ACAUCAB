document.addEventListener('DOMContentLoaded', function () {
    // Inicializar funcionalidades del carrito
    initCartUpdateButtons();
    initCartDropdown();
});

function initCartUpdateButtons() {
    let updateBtns = document.getElementsByClassName('update-cart');

    for (let i = 0; i < updateBtns.length; i++) {
        updateBtns[i].addEventListener('click', function () {
        // Verificar si el botón está deshabilitado
        if (this.disabled) {
            return; // No hacer nada si el botón está deshabilitado
        }

            let productId = this.dataset.product;
            let action = this.dataset.action;
            let tipo = this.dataset.tipo || 'fisica';  // 👈 importante

            fetch(`/update_cart/${tipo}/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': getCookie('csrftoken'),
                },
                body: JSON.stringify({ productId, action })
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'ok') {
                    let cartTotal = document.getElementById('cart-total');
                    if (cartTotal) {
                        cartTotal.innerText = data.cartItems;
                    }

                    // Invalidar caché del dropdown para que se recargue
                    cartDropdownCache = null;

                    if (window.location.pathname.includes('/cart/')) {
                        location.reload();
                    }
                } else {
                    console.warn('Error al actualizar carrito:', data.message);
                }
            })
            .catch(err => console.error('Error en fetch carrito:', err));
        });
    }
}

// Variables globales para el dropdown del carrito
let cartDropdownCache = null;
let cartDropdownLoading = false;
let cartDropdownTimeout = null;

function initCartDropdown() {
    const cartContainer = document.querySelector('.cart-dropdown-container');
    const cartDropdown = document.getElementById('cart-dropdown');
    
    if (!cartContainer || !cartDropdown) {
        return;
    }

    // Evento de hover para mostrar el dropdown
    cartContainer.addEventListener('mouseenter', function() {
        clearTimeout(cartDropdownTimeout);
        loadCartDropdownData();
    });

    // Evento para ocultar el dropdown con delay
    cartContainer.addEventListener('mouseleave', function() {
        cartDropdownTimeout = setTimeout(() => {
            // El CSS se encarga de ocultar el dropdown
        }, 100);
    });
}

function loadCartDropdownData() {
    if (cartDropdownLoading) {
        return;
    }

    const dropdownContent = document.getElementById('cart-dropdown-content');
    if (!dropdownContent) {
        return;
    }

    // Si tenemos datos en caché, usarlos
    if (cartDropdownCache) {
        renderCartDropdown(cartDropdownCache);
        return;
    }

    cartDropdownLoading = true;
    
    // Mostrar estado de carga
    dropdownContent.innerHTML = `
        <div class="cart-dropdown-loading">
            <div class="spinner-border spinner-border-sm" role="status">
                <span class="visually-hidden">Cargando...</span>
            </div>
            <div class="mt-2">Cargando carrito...</div>
        </div>
    `;

    fetch('/cart-dropdown-data/', {
        method: 'GET',
        headers: {
            'X-CSRFToken': getCookie('csrftoken'),
        }
    })
    .then(response => response.json())
    .then(data => {
        cartDropdownCache = data;
        renderCartDropdown(data);
    })
    .catch(error => {
        console.error('Error cargando datos del carrito:', error);
        dropdownContent.innerHTML = `
            <div class="cart-empty-state">
                <div class="cart-empty-icon">⚠️</div>
                <p class="cart-empty-text">Error al cargar el carrito</p>
            </div>
        `;
    })
    .finally(() => {
        cartDropdownLoading = false;
    });
}

function renderCartDropdown(data) {
    const dropdownContent = document.getElementById('cart-dropdown-content');
    if (!dropdownContent) {
        return;
    }

    if (data.empty || data.items.length === 0) {
        dropdownContent.innerHTML = `
            <div class="cart-empty-state">
                <div class="cart-empty-icon">🛒</div>
                <p class="cart-empty-text">Tu carrito está vacío</p>
            </div>
        `;
        return;
    }

    let itemsHtml = '';
    data.items.forEach(item => {
        const imageHtml = item.image 
            ? `<img src="${item.image}" alt="${item.name}" class="cart-item-image">`
            : `<div class="cart-item-placeholder">Sin imagen</div>`;

        itemsHtml += `
            <div class="cart-item" data-product-id="${item.product_id}">
                ${imageHtml}
                <div class="cart-item-details">
                    <p class="cart-item-name">${item.name}</p>
                    <div class="cart-item-quantity-controls">
                        <button class="btn btn-sm btn-outline-danger cart-btn-remove" 
                                data-product="${item.product_id}" 
                                data-action="remove" 
                                data-tipo="fisica"
                                title="Quitar uno">
                            <i class="fas fa-minus"></i>
                        </button>
                        <span class="cart-item-quantity-display">${item.quantity}</span>
                        <button class="btn btn-sm btn-outline-success cart-btn-add" 
                                data-product="${item.product_id}" 
                                data-action="add" 
                                data-tipo="fisica"
                                title="Agregar uno">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                    <p class="cart-item-price">
                        $${item.subtotal_usd.toFixed(2)} USD
                        <span class="cart-item-price-secondary">
                            (${item.subtotal_bs.toFixed(2)} Bs)
                        </span>
                    </p>
                </div>
            </div>
        `;
    });

    // Añadir resumen de totales
    const totalHtml = `
        <div class="cart-total-summary">
            <div class="cart-total-row">
                <span class="cart-total-label">Items:</span>
                <span class="cart-total-value">${data.total_items}</span>
            </div>
            <div class="cart-total-row">
                <span class="cart-total-label">Total USD:</span>
                <span class="cart-total-value primary">$${data.total_usd.toFixed(2)}</span>
            </div>
            <div class="cart-total-row">
                <span class="cart-total-label">Total Bs:</span>
                <span class="cart-total-value">${data.total_bs.toFixed(2)} Bs</span>
            </div>
            <div class="cart-total-row">
                <span class="cart-total-label">Tasa del día:</span>
                <span class="cart-total-value">${data.dollar_rate.toFixed(2)} Bs/$</span>
            </div>
        </div>
    `;

    dropdownContent.innerHTML = itemsHtml + totalHtml;
    
    // Añadir event listeners para los botones del dropdown
    attachCartDropdownEventListeners();
}

function attachCartDropdownEventListeners() {
    const cartBtns = document.querySelectorAll('.cart-btn-add, .cart-btn-remove');
    
    cartBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            // Verificar si el botón está deshabilitado
            if (this.disabled) {
                return;
            }
            
            const productId = this.dataset.product;
            const action = this.dataset.action;
            const tipo = this.dataset.tipo || 'fisica';
            
            // Deshabilitar botón temporalmente
            this.disabled = true;
            const originalContent = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
            
            // Hacer petición AJAX
            fetch(`/update_cart/${tipo}/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': getCookie('csrftoken'),
                },
                body: JSON.stringify({ productId, action })
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'ok') {
                    // Actualizar contador del carrito
                    const cartTotal = document.getElementById('cart-total');
                    if (cartTotal) {
                        cartTotal.innerText = data.cartItems;
                    }
                    
                    // Invalidar caché del dropdown para que se recargue
                    cartDropdownCache = null;
                    
                    // Recargar contenido del dropdown
                    loadCartDropdownData();
                    
                    // Mostrar feedback visual
                    showCartUpdateFeedback(action, productId);
                    
                } else {
                    console.warn('Error al actualizar carrito:', data.message);
                    showCartError(data.message || 'Error al actualizar el carrito');
                }
            })
            .catch(err => {
                console.error('Error en petición del carrito:', err);
                showCartError('Error de conexión. Intente nuevamente.');
            })
            .finally(() => {
                // Rehabilitar botón
                this.disabled = false;
                this.innerHTML = originalContent;
            });
        });
    });
}

function showCartUpdateFeedback(action, productId) {
    const cartItem = document.querySelector(`[data-product-id="${productId}"]`);
    if (cartItem) {
        // Efecto de highlight en el item completo
        cartItem.classList.add('cart-item-updated');
        setTimeout(() => {
            cartItem.classList.remove('cart-item-updated');
        }, 1000);
        
        // Efecto de pulso en la cantidad
        const quantityDisplay = cartItem.querySelector('.cart-item-quantity-display');
        if (quantityDisplay) {
            quantityDisplay.classList.add('quantity-changed');
            setTimeout(() => {
                quantityDisplay.classList.remove('quantity-changed');
            }, 500);
        }
    }
}

function showCartError(message) {
    // Crear y mostrar notificación de error
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger alert-dismissible fade show cart-dropdown-alert';
    alertDiv.innerHTML = `
        <i class="fas fa-exclamation-triangle me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    const dropdownContent = document.getElementById('cart-dropdown-content');
    if (dropdownContent) {
        dropdownContent.insertBefore(alertDiv, dropdownContent.firstChild);
        
        // Auto-dismiss después de 4 segundos
        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 4000);
    }
}

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}