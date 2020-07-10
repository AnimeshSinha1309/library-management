function getter() {
    var ele = document.getElementsByClassName("bookTitle"); var x = [];
    for (var i = 0; i < 100; i++) x.push(ele[i].firstElementChild.innerText); return x;
}