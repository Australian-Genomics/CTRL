<template>
  <div>
    <div class="d-flex mb-30">
      <p class="text-center mx-auto mb-0">
        {{ surveyStep.description }}
      </p>
    </div>

    <div class="steps__iframe">
      <iframe
        width="100%"
        height="100%"
        :src="iframeSrc"
        frameborder="0"
        allow="autoplay; encrypted-media"
        allowfullscreen
      ></iframe>
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
