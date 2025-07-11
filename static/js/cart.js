// CARRITO JAVASCRIPT - Manejo del carrito para tienda física, online y eventos

// Variables globales
let cartDropdownTimeout;

// Inicialización cuando el DOM está listo
document.addEventListener('DOMContentLoaded', function() {
    initializeCart();
    loadCartDropdown();
});

function initializeCart() {
    // Vincular todos los botones de carrito
    bindCartButtons();
    
    // Inicializar dropdown del carrito
    initCartDropdown();
}

function bindCartButtons() {
    // Botones estándar de carrito (física/online)
    const updateCartBtns = document.querySelectorAll('.update-cart');
    updateCartBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const productId = this.dataset.product;
            const action = this.dataset.action;
            const tipo = this.dataset.tipo || detectStoreType();
            
            if (productId && action) {
                updateCart(productId, action, tipo);
            }
        });
    });

    // Botones de eventos (ya manejados en tienda_evento.html)
    // No necesitamos re-vincularlos aquí para evitar conflictos
}

function detectStoreType() {
    // Detectar tipo de tienda basándose en la URL actual
    const currentPath = window.location.pathname;
    
    if (currentPath.includes('/store/online/')) {
        return 'online';
    } else if (currentPath.includes('/store/fisica/')) {
        return 'fisica';
    } else if (currentPath.includes('/tienda-eventos/')) {
        return 'venta_evento';
    } else if (currentPath.includes('/eventos/')) {
        return 'evento';
    }
    
    // Por defecto, física
    return 'fisica';
}

function updateCart(productId, action, tipo = 'fisica') {
    console.log('Actualizando carrito:', { productId, action, tipo });
    
    const url = getUpdateCartUrl(tipo);
    
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCookie('csrftoken'),
        },
        body: JSON.stringify({
            'productId': productId,
            'action': action
        })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        console.log('Respuesta del carrito:', data);
        
        if (data.status === 'ok') {
            updateCartDisplay(data.cartItems);
            loadCartDropdown(); // Recargar dropdown
            showCartNotification('Producto agregado al carrito', 'success');
        } else {
            showCartNotification(data.message || 'Error al actualizar carrito', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showCartNotification('Error de conexión', 'error');
    });
}

function getUpdateCartUrl(tipo) {
    switch(tipo) {
        case 'evento':
            return '/update_cart/evento/';
        case 'venta_evento':
            return '/update-cart-evento/';
        case 'online':
            return '/update_cart/online/';
        case 'fisica':
        default:
            return '/update_cart/fisica/';
    }
}

function updateCartDisplay(cartItems) {
    const cartTotal = document.getElementById('cart-total');
    if (cartTotal) {
        cartTotal.textContent = cartItems;
        
        // Animación del contador
        cartTotal.style.transform = 'scale(1.3)';
        setTimeout(() => {
            cartTotal.style.transform = 'scale(1)';
        }, 200);
    }
}

function showCartNotification(message, type) {
    // Remover notificación existente si la hay
    const existingNotification = document.querySelector('.cart-notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    const notification = document.createElement('div');
    notification.className = `alert alert-${type === 'success' ? 'success' : 'danger'} cart-notification`;
    notification.style.cssText = `
        position: fixed;
        top: 80px;
        right: 20px;
        z-index: 9999;
        min-width: 300px;
        max-width: 400px;
        animation: slideInRight 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    `;
    
    notification.innerHTML = `
        <div class="d-flex align-items-center">
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'} me-2"></i>
            <span>${message}</span>
            <button type="button" class="btn-close ms-auto" aria-label="Close"></button>
        </div>
    `;
    
    document.body.appendChild(notification);
    
    // Vincular botón de cerrar
    const closeBtn = notification.querySelector('.btn-close');
    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            hideNotification(notification);
        });
    }
    
    // Auto-remover después de 4 segundos
    setTimeout(() => {
        hideNotification(notification);
    }, 4000);
}

function hideNotification(notification) {
    if (notification && notification.parentNode) {
        notification.style.animation = 'slideOutRight 0.3s ease';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }
}

// DROPDOWN DEL CARRITO
function initCartDropdown() {
    const cartContainer = document.querySelector('.cart-dropdown-container');
    if (!cartContainer) return;
    
    const cartDropdown = document.querySelector('.cart-dropdown');
    if (!cartDropdown) return;
    
    // Manejar hover
    cartContainer.addEventListener('mouseenter', () => {
        clearTimeout(cartDropdownTimeout);
        loadCartDropdown();
    });
    
    cartContainer.addEventListener('mouseleave', () => {
        cartDropdownTimeout = setTimeout(() => {
            // El dropdown se oculta automáticamente con CSS
        }, 300);
    });
    
    // Prevenir que el dropdown se cierre cuando se hace hover sobre él
    cartDropdown.addEventListener('mouseenter', () => {
        clearTimeout(cartDropdownTimeout);
    });
}

function loadCartDropdown() {
    const cartContent = document.querySelector('.cart-dropdown-content');
    if (!cartContent) return;
    
    const tipo = detectStoreType();
    
    fetch(`/cart-dropdown-data/?tipo=${tipo}`, {
        method: 'GET',
        headers: {
            'X-CSRFToken': getCookie('csrftoken'),
        }
    })
    .then(response => response.json())
    .then(data => {
        updateCartDropdownContent(data);
    })
    .catch(error => {
        console.error('Error cargando dropdown del carrito:', error);
        updateCartDropdownContent({ empty: true, error: true });
    });
}

function updateCartDropdownContent(data) {
    const cartContent = document.querySelector('.cart-dropdown-content');
    const cartFooter = document.querySelector('.cart-dropdown-footer');
    
    if (!cartContent) return;
    
    if (data.error) {
        cartContent.innerHTML = `
            <div class="cart-dropdown-loading">
                <i class="fas fa-exclamation-triangle text-warning"></i>
                <p class="mb-0 mt-2">Error cargando carrito</p>
            </div>
        `;
        return;
    }
    
    if (data.empty) {
        cartContent.innerHTML = `
            <div class="cart-empty-state">
                <div class="cart-empty-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <p class="cart-empty-text">Tu carrito está vacío</p>
            </div>
        `;
        
        if (cartFooter) {
            cartFooter.style.display = 'none';
        }
        return;
    }
    
    // Actualizar contador en el icono del carrito
    updateCartDisplay(data.total_items);
    
    // Construir HTML de items
    let itemsHtml = '';
    data.items.forEach(item => {
        const isTicket = item.is_ticket || false;
        const imageHtml = item.image ? 
            `<img src="${item.image}" alt="${item.name}" class="cart-item-image">` :
            `<div class="cart-item-placeholder">
                <i class="fas fa-${isTicket ? 'ticket-alt' : 'box'}"></i>
            </div>`;
        
        itemsHtml += `
            <div class="cart-item" data-product-id="${item.product_id}">
                ${imageHtml}
                <div class="cart-item-details">
                    <h6 class="cart-item-name">${item.name}</h6>
                    ${isTicket ? '<span class="badge badge-secondary">Entrada</span>' : ''}
                    <div class="cart-item-quantity-controls">
                        <button class="cart-btn-remove" data-product-id="${item.product_id}" data-action="remove">
                            <i class="fas fa-minus"></i>
                        </button>
                        <span class="cart-item-quantity-display">${item.quantity}</span>
                        <button class="cart-btn-add" data-product-id="${item.product_id}" data-action="add">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                    <div class="cart-item-price">
                        $${item.price_usd.toFixed(2)}
                        <span class="cart-item-price-secondary">${item.price_bs.toFixed(2)} Bs</span>
                    </div>
                </div>
            </div>
        `;
    });
    
    cartContent.innerHTML = itemsHtml;
    
    // Mostrar footer con totales
    if (cartFooter) {
        cartFooter.style.display = 'block';
        cartFooter.innerHTML = `
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
                    <small class="cart-total-label">Tasa: ${data.dollar_rate.toFixed(2)} Bs/USD</small>
                </div>
            </div>
            <div class="text-center">
                <a href="/cart/${data.tipo}/" class="btn btn-primary btn-sm w-100">
                    <i class="fas fa-shopping-cart me-1"></i>Ver Carrito
                </a>
            </div>
        `;
    }
    
    // Vincular botones de cantidad en el dropdown
    bindCartDropdownButtons();
}

function bindCartDropdownButtons() {
    const cartBtns = document.querySelectorAll('.cart-btn-add, .cart-btn-remove');
    cartBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const productId = this.dataset.productId;
            const action = this.dataset.action;
            const tipo = detectStoreType();
            
            // Deshabilitar botón temporalmente
            this.disabled = true;
            
            if (tipo === 'venta_evento') {
                updateCartEvento(productId, action, '', this);
            } else {
                updateCart(productId, action, tipo);
            }
            
            // Re-habilitar botón después de un momento
            setTimeout(() => {
                this.disabled = false;
            }, 1000);
        });
    });
}

// Función para manejar carrito de eventos (similar a la del template)
function updateCartEvento(itemId, action, itemName = '', buttonElement = null) {
    fetch('/update-cart-evento/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCookie('csrftoken')
        },
        body: JSON.stringify({
            'itemId': itemId,
            'action': action
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'ok') {
            updateCartDisplay(data.cartItems);
            loadCartDropdown();
            
            if (itemName) {
                showCartNotification(`${itemName} ${action === 'add' ? 'agregado al' : 'removido del'} carrito`, 'success');
            }
        } else {
            showCartNotification(data.message || 'Error al actualizar carrito', 'error');
        }
        
        if (buttonElement) {
            buttonElement.disabled = false;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showCartNotification('Error de conexión', 'error');
        
        if (buttonElement) {
            buttonElement.disabled = false;
        }
    });
}

// Función utilitaria para obtener cookies
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

// Exportar funciones para uso global
window.updateCart = updateCart;
window.updateCartEvento = updateCartEvento;
window.loadCartDropdown = loadCartDropdown;