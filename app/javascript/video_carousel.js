function initVideoCarousel() {
  const carousel = document.getElementById("videoCarousel");
  if (!carousel) return;

  carousel.addEventListener("slide.bs.carousel", function (event) {
    const nextSlide = event.relatedTarget;
    const iframe = nextSlide.querySelector("iframe");
    if (iframe && !iframe.src) {
      iframe.src = iframe.dataset.src;
    }
  });

  const firstSlideIframe = carousel.querySelector(".carousel-item.active iframe");
  if (firstSlideIframe && !firstSlideIframe.src) {
    firstSlideIframe.src = firstSlideIframe.dataset.src;
  }
}

document.addEventListener("turbo:load", initVideoCarousel);
document.addEventListener("DOMContentLoaded", initVideoCarousel);
