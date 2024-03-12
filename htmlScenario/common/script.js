function extend(container) {
    console.log("extend");
    var recipe = container.querySelector('#content');
    var imageHeader = container.querySelector('.recipe-image-header');
    console.log(recipe)
    if (recipe.style.display === "block") {
        recipe.style.display = "none";
        imageHeader.style.display = "block";
    } else {
        recipe.style.display = "block";
        imageHeader.style.display= "none";
    }
  }