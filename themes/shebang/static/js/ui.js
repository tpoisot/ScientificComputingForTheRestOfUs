document.querySelector(".button").addEventListener('click', () => {
  document.querySelector(".content").classList.toggle('isOpen');
});

function toggle_status() {
    var div = document.getElementById('status');
    div.style.display = div.style.display == 'none' ? 'block' : 'none';
    return false;
}
