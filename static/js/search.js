// search.js - Funcionalidad de búsqueda en tiempo real
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('search-input');
    const productsContainer = document.getElementById('products-container');
    const noResultsDiv = document.getElementById('no-results');
    const resultsCount = document.getElementById('search-results-count');
    
    if (!searchInput) return; // Si no estamos en la página de la tienda, salir

    let searchTimeout;
    let allProducts = [];
    let totalProducts = 0;

    // Inicializar la búsqueda
    function initializeSearch() {
        allProducts = Array.from(document.querySelectorAll('.product-item'));
        totalProducts = allProducts.length;
        updateResultsCount(totalProducts, totalProducts);
    }

    // Función de búsqueda
    function performSearch(searchTerm) {
        const term = searchTerm.toLowerCase().trim();
        let visibleCount = 0;

        // Agregar clase de búsqueda para animaciones
        productsContainer.classList.add('searching');

        allProducts.forEach(product => {
            const productName = product.getAttribute('data-product-name');
            const isMatch = !term || productName.includes(term);

            if (isMatch) {
                product.classList.remove('hidden');
                product.classList.add('match');
                visibleCount++;
            } else {
                product.classList.add('hidden');
                product.classList.remove('match');
            }
        });

        // Mostrar/ocultar mensaje de no resultados
        if (visibleCount === 0 && term) {
            noResultsDiv.style.display = 'block';
            productsContainer.style.display = 'none';
        } else {
            noResultsDiv.style.display = 'none';
            productsContainer.style.display = 'flex';
        }

        // Actualizar contador de resultados
        updateResultsCount(visibleCount, totalProducts, term);

        // Remover clase de búsqueda después de la animación
        setTimeout(() => {
            productsContainer.classList.remove('searching');
        }, 300);
    }

    // Actualizar contador de resultados
    function updateResultsCount(visible, total, searchTerm = '') {
        if (searchTerm) {
            if (visible === 0) {
                resultsCount.textContent = `No se encontraron productos para "${searchTerm}"`;
                resultsCount.className = 'mt-2 text-danger';
            } else if (visible === 1) {
                resultsCount.textContent = `Se encontró 1 producto para "${searchTerm}"`;
                resultsCount.className = 'mt-2 text-success';
            } else {
                resultsCount.textContent = `Se encontraron ${visible} productos para "${searchTerm}"`;
                resultsCount.className = 'mt-2 text-success';
            }
        } else {
            resultsCount.textContent = `Mostrando ${total} productos`;
            resultsCount.className = 'mt-2 text-muted';
        }
    }

    // Event listener para el input de búsqueda
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value;

        // Limpiar timeout anterior
        clearTimeout(searchTimeout);

        // Búsqueda con debounce (esperar 300ms después de que el usuario deje de escribir)
        searchTimeout = setTimeout(() => {
            performSearch(searchTerm);
        }, 300);
    });

    // Limpiar búsqueda al presionar Escape
    searchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            this.value = '';
            performSearch('');
            this.blur();
        }
    });

    // Inicializar cuando se carga la página
    initializeSearch();

    // Funcionalidad adicional: búsqueda por Enter
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            clearTimeout(searchTimeout);
            performSearch(this.value);
        }
    });

    // Función para limpiar la búsqueda (puede ser llamada desde otros scripts)
    window.clearSearch = function() {
        searchInput.value = '';
        performSearch('');
    };

    // Función para buscar un término específico (puede ser llamada desde otros scripts)
    window.searchProducts = function(term) {
        searchInput.value = term;
        performSearch(term);
    };
}); 