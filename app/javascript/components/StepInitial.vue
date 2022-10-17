<template>
  <div>
    <div class="d-flex mb-30">
      <p class="text-justify mx-auto mb-0" v-html="surveyStep.description"></p>
    </div>
    <div class="steps__iframe" v-if="surveyStep.tour_videos">
      <div id="carouselIndicators" class="carousel slide" data-ride="carousel" data-interval="false">
        <ol class="carousel-indicators">
          <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
          <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
          <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
        </ol>
        <div class="carousel-inner">
          <div class="carousel-item " v-for="(video, index) in surveyStep.tour_videos"
               v-bind:key="`tourVideo-${index}`" v-bind:class="{ active: index===0 }">
            <iframe
                :src="video"
                frameborder="0"
                allow="autoplay; encrypted-media"
                allowfullscreen
            ></iframe>
          </div>
        </div>
        <a class="carousel-control-prev" href="#carouselIndicators" role="button" data-slide="prev">
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#carouselIndicators" role="button" data-slide="next">
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="sr-only">Next</span>
        </a>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'StepInitial',
  props: {
    iframeSrc: {
      type: String,
      required: true
    },
    surveyStep: {
      type: Object,
      required: true
    }
  }
}
</script>
