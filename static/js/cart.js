document.addEventListener('DOMContentLoaded', function () {
    let updateBtns = document.getElementsByClassName('update-cart');

    for (let i = 0; i < updateBtns.length; i++) {
        updateBtns[i].addEventListener('click', function () {
        // Verificar si el botón está deshabilitado
        if (this.disabled) {
            return; // No hacer nada si el botón está deshabilitado
        }

            let productId = this.dataset.product;
            let action = this.dataset.action;
            let tipo = this.dataset.tipo || 'online';  // 👈 importante

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
});

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