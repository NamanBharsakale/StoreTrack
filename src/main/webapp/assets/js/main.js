/* StoreTrack — main.js */

// Mark the current sidebar link as active
(function () {
    const path = window.location.pathname;
    document.querySelectorAll('.sidebar-nav a').forEach(function (link) {
        const href = link.getAttribute('href');
        if (href && path.startsWith(href) && href !== '/') {
            link.classList.add('active');
        }
    });
})();

// Auto-dismiss alerts after 4 seconds
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.alert-dismissible').forEach(function (el) {
        setTimeout(function () {
            var bsAlert = bootstrap.Alert.getOrCreateInstance(el);
            if (bsAlert) bsAlert.close();
        }, 4000);
    });
});

// ── Billing page logic ──
var cart = [];

function searchProduct() {
    var q = document.getElementById('productSearch').value.trim();
    if (q.length < 2) {
        document.getElementById('searchResults').innerHTML = '';
        return;
    }
    var all = window.allProducts || [];
    var results = all.filter(function (p) {
        return p.name.toLowerCase().includes(q.toLowerCase());
    });
    var html = '';
    results.forEach(function (p) {
        html += '<div class="search-item" onclick="addToCart(' + JSON.stringify(p).replace(/"/g, '&quot;') + ')">' +
                '<strong>' + p.name + '</strong> &mdash; ₹' + p.sellingPrice.toFixed(2) +
                ' <small class="text-muted">(' + p.quantity + ' ' + p.unit + ' available)</small></div>';
    });
    document.getElementById('searchResults').innerHTML = html;
}

function addToCart(product) {
    document.getElementById('searchResults').innerHTML = '';
    document.getElementById('productSearch').value = '';

    var existing = cart.find(function (i) { return i.productId === product.id; });
    if (existing) {
        existing.qty += 1;
    } else {
        cart.push({ productId: product.id, name: product.name, qty: 1,
                    unitPrice: product.sellingPrice, unit: product.unit,
                    maxQty: product.quantity });
    }
    renderCart();
}

function removeFromCart(productId) {
    cart = cart.filter(function (i) { return i.productId !== productId; });
    renderCart();
}

function renderCart() {
    var tbody = document.getElementById('cartBody');
    var tax   = parseFloat(document.getElementById('taxRate').value) || 0;
    if (!tbody) return;

    if (cart.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted py-4">No items added yet</td></tr>';
        updateTotals(0, tax);
        return;
    }

    var html = '';
    var subtotal = 0;
    cart.forEach(function (item) {
        var lineTotal = item.qty * item.unitPrice;
        subtotal += lineTotal;
        html += '<tr>' +
                '<td>' + item.name + '</td>' +
                '<td>' +
                  '<input type="number" class="form-control form-control-sm" style="width:80px" ' +
                  'value="' + item.qty + '" min="1" max="' + item.maxQty + '" ' +
                  'onchange="updateQty(' + item.productId + ', this.value)">' +
                '</td>' +
                '<td>₹' + item.unitPrice.toFixed(2) + '</td>' +
                '<td>₹' + lineTotal.toFixed(2) + '</td>' +
                '<td><button class="btn btn-sm btn-outline-danger" onclick="removeFromCart(' + item.productId + ')">' +
                  '<i class="bi bi-trash"></i></button></td>' +
                '</tr>';
    });
    tbody.innerHTML = html;
    updateTotals(subtotal, tax);
}

function updateQty(productId, val) {
    var item = cart.find(function (i) { return i.productId === productId; });
    if (item) {
        item.qty = Math.max(1, Math.min(parseInt(val) || 1, item.maxQty));
        renderCart();
    }
}

function updateTotals(subtotal, taxRate) {
    var tax   = subtotal * taxRate / 100;
    var total = subtotal + tax;
    var el    = function (id) { return document.getElementById(id); };
    if (el('subtotalAmt')) el('subtotalAmt').textContent = '₹' + subtotal.toFixed(2);
    if (el('taxAmt'))      el('taxAmt').textContent      = '₹' + tax.toFixed(2);
    if (el('totalAmt'))    el('totalAmt').textContent    = '₹' + total.toFixed(2);
}

function submitSale() {
    if (cart.length === 0) { alert('Add at least one product to the cart.'); return; }

    var form   = document.getElementById('saleForm');
    var hidden = document.getElementById('cartHidden');
    hidden.innerHTML = '';

    cart.forEach(function (item) {
        hidden.innerHTML +=
            '<input type="hidden" name="productId" value="' + item.productId + '">' +
            '<input type="hidden" name="qty" value="' + item.qty + '">' +
            '<input type="hidden" name="unitPrice" value="' + item.unitPrice + '">';
    });

    form.submit();
}
