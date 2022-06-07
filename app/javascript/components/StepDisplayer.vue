<template>
  <header id="header" class="header header_steps position-relative bg-ice-one">
    <div class="container">
      <div class="row px-15">
        <div class="header__logo-wrapper col-12 d-flex">
          <a
            href="/"
            class="header__logo d-block mt-45 mx-auto ml-xl-0"
          >
             <img
              src="~images/australian-genomics-logo.png"
              alt="logo"
              class="h-100"
            >
          </a>
        </div>
        <div class="col-12 col-lg-8 col-lg mx-auto mt-30 mt-xl-45">
          <div class="header__progress-wrapper mx-auto">
            <div>
              Step {{ consentStep }} of {{ consentStepTotal }}
            </div>
            <progress-bar
              :options="progressBarStyle"
              :value="progressBarValue"
            />
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script>

import ProgressBar from 'vuejs-progress-bar'

export default {
  name: 'StepDisplayer',
  components: {
    ProgressBar
  },
  props: {
    consentStep: {
      type: Number,
      required: true
    },
    consentStepTotal: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      progressBarStyle: {
        text: {
          hideText: true
        },
        progress: {
          color: '#02b0db',
          backgroundColor: '#e7eaef',
          inverted: false
        },
        layout: {
          height: 4,
          width: 459,
          verticalTextAlign: 61,
          horizontalTextAlign: 43,
          zeroOffset: 0,
          strokeWidth: 30,
          progressPadding: 0,
          type: 'line'
        }
      }
    }
  },
  computed: {
    progressBarValue() {
      return 100 / this.consentStepTotal * this.consentStep
    }
  }
}
</script>
