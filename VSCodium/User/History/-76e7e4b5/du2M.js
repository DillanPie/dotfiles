// navbar.js

document.addEventListener("DOMContentLoaded", () => {
    fetch('partials/navbar.html')
        .then(response => response.text())
        .then(data => {
            document.getElementById('navbar').innerHTML = data;

            // Highlight Active Link Based on URL
            const links = document.querySelectorAll('.navbar a');
            links.forEach(link => {
                if (link.href === window.location.href) {
                    link.classList.add('active');

                    // Optional: Smooth Fade-In Effect for Active Link
                    link.style.opacity = '0';
                    setTimeout(() => {
                        link.style.transition = 'opacity 0.6s';
                        link.style.opacity = '1';
                    }, 100);
                }
            });
        })
        .catch(error => console.error('Error loading navbar:', error));
});
