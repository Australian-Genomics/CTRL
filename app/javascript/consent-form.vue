<template>
  <div id="consent-form">

    <StepDisplayer
      :consentStep="consentStep"
      :consentStepTotal="consentStepTotal"
    />

    <section class="steps steps_pushed-up container">
      <div class="row">
        <div class="steps__box col mx-auto">
          <div class="bg-ice-one border p-15">
            <StepInitial
              :iframeSrc="'stubStepURL'"
            />

            <div class="row flex-md-row-reverse">
              <div class="col-12 col-md-3 d-flex my-15 my-md-30">
                <button
                  v-on:click="nextPage"
                  class="btn btn-success mx-auto mr-md-0"
                >
                  Next
                </button>
              </div>

              <div class="col-12 col-md-6 offset-md-3 d-flex mb-30 mt-md-30">
                <button class="steps__btn-save btn btn-primary mx-auto">
                  Save and Exit
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>

import StepDisplayer from './components/StepDisplayer'
import StepInitial from './components/StepInitial'

export default {
  components: {
    StepDisplayer,
    StepInitial
  },
  data() {
    return {
      consentStep: 1,
      consentStepTotal: 5
    }
  },
  methods: {
    nextPage() {
      this.consentStep += 1
    },
    saveAndExit() {

    }
  },
  computed: {
  }
}
</script>

