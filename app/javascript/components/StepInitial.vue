<template>
  <div class="d-flex mb-30">
    <p class="text-center mx-auto mb-0">
      Watch our short video about thes consent process for taking part in medical research, and how you can use this website during the study.
    </p>
  </div>

  <div class="steps__iframe">
    <iframe
      width="100%"
      height="100%"
      :src=""
      frameborder="0"
      allow="autoplay; encrypted-media"
      allowfullscreen
    ></iframe>
  </div>
</template>

<script>

export default {
  name: 'StepInitial',
  props: {
    iframeSrc: {
      type: String,
      required: true
    }
  }
}
</script>
