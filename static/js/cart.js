document.addEventListener('DOMContentLoaded', function () {
    initCartUpdateButtons();
    initCartDropdown();
});

function initCartUpdateButtons() {
    let updateBtns = document.getElementsByClassName('update-cart');

    for (let btn of updateBtns) {
        btn.addEventListener('click', function () {
            if (this.disabled) return;

            const productId = this.dataset.product;
            const action = this.dataset.action;
            const tipo = this.dataset.tipo || 'fisica';

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
                    const cartTotal = document.getElementById('cart-total');
                    if (cartTotal) cartTotal.innerText = data.cartItems;

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

let cartDropdownCache = null;
let cartDropdownLoading = false;
let cartDropdownTimeout = null;

function initCartDropdown() {
    const cartContainer = document.querySelector('.cart-dropdown-container');
    const cartDropdown = document.getElementById('cart-dropdown');
    if (!cartContainer || !cartDropdown) return;

    cartContainer.addEventListener('mouseenter', () => {
        clearTimeout(cartDropdownTimeout);
        loadCartDropdownData();
    });

    cartContainer.addEventListener('mouseleave', () => {
        cartDropdownTimeout = setTimeout(() => {}, 100);
    });
}

function loadCartDropdownData() {
    if (cartDropdownLoading) return;

    const dropdownContent = document.getElementById('cart-dropdown-content');
    if (!dropdownContent) return;

    if (cartDropdownCache) {
        renderCartDropdown(cartDropdownCache);
        return;
    }

    cartDropdownLoading = true;
    dropdownContent.innerHTML = `
        <div class="cart-dropdown-loading">
            <div class="spinner-border spinner-border-sm" role="status">
                <span class="visually-hidden">Cargando...</span>
            </div>
            <div class="mt-2">Cargando carrito...</div>
        </div>
    `;

    const storeType = window.currentStoreType || 'fisica';

    fetch(`/cart-dropdown-data/?tipo=${storeType}`, {
        method: 'GET',
        headers: { 'X-CSRFToken': getCookie('csrftoken') }
    })
    .then(res => res.json())
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
    if (!dropdownContent) return;

    if (data.empty || data.items.length === 0) {
        dropdownContent.innerHTML = `
            <div class="cart-empty-state">
                <div class="cart-empty-icon">🛒</div>
                <p class="cart-empty-text">Tu carrito está vacío</p>
            </div>
        `;
        return;
    }

    const storeType = data.tipo || window.currentStoreType || 'fisica';

    let itemsHtml = data.items.map(item => `
        <div class="cart-item" data-product-id="${item.product_id}">
            ${item.image ? `<img src="${item.image}" alt="${item.name}" class="cart-item-image">` : '<div class="cart-item-placeholder">Sin imagen</div>'}
            <div class="cart-item-details">
                <p class="cart-item-name">${item.name}</p>
                <div class="cart-item-quantity-controls">
                    <button class="btn btn-sm btn-outline-danger cart-btn-remove" 
                            data-product="${item.product_id}" 
                            data-action="remove" 
                            data-tipo="${storeType}" title="Quitar uno">
                        <i class="fas fa-minus"></i>
                    </button>
                    <span class="cart-item-quantity-display">${item.quantity}</span>
                    <button class="btn btn-sm btn-outline-success cart-btn-add" 
                            data-product="${item.product_id}" 
                            data-action="add" 
                            data-tipo="${storeType}" title="Agregar uno">
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
    `).join('');

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
        </div>
    `;

    dropdownContent.innerHTML = itemsHtml + totalHtml;
    attachCartDropdownEventListeners();
}

function attachCartDropdownEventListeners() {
    document.querySelectorAll('.cart-btn-add, .cart-btn-remove').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            if (this.disabled) return;

            const productId = this.dataset.product;
            const action = this.dataset.action;
            const tipo = this.dataset.tipo || 'fisica';
            const originalContent = this.innerHTML;

            this.disabled = true;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

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
                    const cartTotal = document.getElementById('cart-total');
                    if (cartTotal) cartTotal.innerText = data.cartItems;
                    cartDropdownCache = null;
                    loadCartDropdownData();
                    showCartUpdateFeedback(action, productId);
                } else {
                    showCartError(data.message || 'Error al actualizar el carrito');
                }
            })
            .catch(() => showCartError('Error de conexión. Intente nuevamente.'))
            .finally(() => {
                this.disabled = false;
                this.innerHTML = originalContent;
            });
        });
    });
}

function showCartUpdateFeedback(action, productId) {
    const cartItem = document.querySelector(`[data-product-id="${productId}"]`);
    if (!cartItem) return;

    cartItem.classList.add('cart-item-updated');
    setTimeout(() => cartItem.classList.remove('cart-item-updated'), 1000);

    const quantityDisplay = cartItem.querySelector('.cart-item-quantity-display');
    if (quantityDisplay) {
        quantityDisplay.classList.add('quantity-changed');
        setTimeout(() => quantityDisplay.classList.remove('quantity-changed'), 500);
    }
}

function showCartError(message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger alert-dismissible fade show cart-dropdown-alert';
    alertDiv.innerHTML = `
        <i class="fas fa-exclamation-triangle me-2"></i>${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

    const dropdownContent = document.getElementById('cart-dropdown-content');
    if (dropdownContent) {
        dropdownContent.insertBefore(alertDiv, dropdownContent.firstChild);
        setTimeout(() => alertDiv.remove(), 4000);
    }
}

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let cookie of cookies) {
            cookie = cookie.trim();
            if (cookie.startsWith(name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}