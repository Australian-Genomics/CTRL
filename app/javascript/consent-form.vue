<template>
  <div id="consent-form">

    <ModalFallback
      :modal="modalFallback"
      v-if="modalFallback"
    />

    <StepDisplayer
      :consentStep="consentStep"
      :consentStepTotal="consentStepTotal"
    />

    <section class="steps steps_pushed-up container">
      <div class="row">
        <div class="steps__box col mx-auto">
          <div
            class="bg-ice-one border"
            v-bind:class="{
              'p-15': isFirstStep,
              'pt-30 px-30': consentStep !== 1
            }"
          >

            <StepInitial
              :iframeSrc="'https://www.youtube.com/embed/Du8kYb_9AKY'"  
              :surveyStep="currentSurveyStep"
              v-if="isFirstStep && currentSurveyStep"
            />
            

            <div v-if="consentStep !== 1">
              <h3 class="text-center mt-2 mb-15">
                {{ currentSurveyStep.title }}
              </h3>

              <div class="d-flex mb-30">
                <p class="steps__description mx-auto mb-0 text-justify"
                  v-html="currentSurveyStep.description">
                </p>
              </div>

              <div
                v-for="(qstionGrp, qGindex) in questionGroups"
                v-bind:key="`qstionGrp-${qGindex}`"
              >
                <div class="steps__general text-center py-2 mb-30"
                  v-if="qstionGrp.header">
                  <b>{{qstionGrp.header}}</b>
                </div>
                <div class="options"
                  v-for="(question, i) in qstionGrp.questions"
                  v-bind:key="`question${question.id}`">

                  <div class="steps__row">
                    <div class="steps__row-main">
                      <div class="mr-auto steps__text-question"
                        v-html="question.question">
                      </div>

                      <i
                        class="icon__i mr-30 mr-sm-60"
                        v-on:click="toggleDescription(question)"
                        v-if="question.description"
                      >
                      </i>

                      <template v-if="question.answer_choices_position === 'right'">
                        <label class="controls controls__checkbox controls__checkbox_blue"
                          v-if="question.question_type == 'checkbox' || question.question_type == 'checkbox agreement'">

                          <input
                            v-model="answers[qGindex][i].answer"
                            type="checkbox"
                            true-value="yes"
                            false-value="no"
                          >
                          <span class="checkmark">
                          </span>
                        </label>

                        <div
                          class="d-flex mt-3 mt-sm-0 text-capitalize"
                          v-else-if="question.question_type === 'multiple choice'"
                        >
                          <span v-for="(option, oi) in question.options">
                            <label>
                              <label class="controls controls__radio controls__radio_blue ml-sm-15">
                                <input type="radio"
                                  v-bind:value="option.value"
                                  v-model="answers[qGindex][i].answer"
                                >
                                <span class="checkmark"></span>
                                <span class="label-text ml-1 mr-1">{{ option.value }}</span>
                              </label>
                            </label>
                          </span>
                        </div>
                      </template">
                    </div>

                    <div class="col-12"
                      v-if="question.question_type === 'multiple choice' &&
                        question.answer_choices_position === 'bottom'">
                      <div class="d-flex mt-3 mt-sm-0 text-capitalize">
                        <span v-for="(option, oi) in question.options">
                          <label>
                            <label class="controls controls__radio controls__radio_blue ml-sm-15">
                              <input type="radio"
                                v-bind:value="option.value"
                                v-model="answers[qGindex][i].answer"
                              >
                              <span class="checkmark"></span>
                              <span class="label-text ml-1 mr-1">{{ option.value }}</span>
                            </label>
                          </label>
                        </span>
                      </div>
                    </div>
                  </div>
                  <div class="steps__row-collapse"
                    v-if="question.show_description && question.description">
                    <div class="steps__text-question"
                      v-html="question.description">
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="row flex-md-row">
              <div class="col-6 col-md-3 order-0 d-flex my-15 my-md-30">
                <button
                  v-on:click="previousStep"
                  v-if="consentStep !== 1"
                  class="btn btn-outline-success mr-auto"
                >
                  Back
                </button>
              </div>

              <div class="col-6 col-md-3 order-1 order-md-2 d-flex my-15 my-md-30">
                <button
                  v-on:click="nextStep"
                  v-if="consentStep !== consentStepTotal"
                  class="btn btn-success ml-auto"
                >
                  Next
                </button>
              </div>

              <div class="col-12 col-md-6 order-2 order-md-1 d-flex mb-30 mt-md-30">
                <button class="steps__btn-save btn btn-primary mx-auto"
                  v-on:click="saveAndExit"
                >
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

import axios from 'axios';
import StepDisplayer from './components/StepDisplayer'
import StepInitial from './components/StepInitial'
import ModalFallback from './components/ModalFallback'

export default {
  components: {
    StepDisplayer,
    StepInitial,
    ModalFallback
  },
  data() {
    return {
      consentStep: 1,
      steps: [],
      answers: []
    }
  },
  methods: {
    nextStep() {
      this.saveAnswers()
      if ( this.modalFallback && this.checkboxAgreement.answer == 'no') {
        this.$modal.show('modal-fallback')
      } else {
        this.consentStep += 1
      }
    },
    previousStep() {
      this.consentStep -= 1
    },
    saveAndExit() {
      this.saveAnswers()
      window.location.href = '/'
    },
    toggleDescription(question) {
      question.show_description = !question.show_description
    },
    fillAnswers() {
      this.answers = [];

      this.currentSurveyStep.groups.forEach((group, gIndex)  => {
        this.answers.push([])
        group.questions.forEach(question => {
          this.answers[gIndex].push({
            consent_question_id: question.id,
            answer: question.answer.answer || question.default_answer,
            question_type: question.question_type
          })
        })
      })
    },
    saveAnswers() {
      const token = document.querySelector('[name=csrf-token]').content
      axios.defaults.headers.common['X-CSRF-TOKEN'] = token

      let answersParams = []

      this.answers.forEach(answerArray => {
        answersParams.push(...answerArray)
      })

      axios.put('/consent-form', {
        consent_step_id: this.currentSurveyStep.id,
        answers: answersParams
      }).then(({ data }) => {
        console.log('success in saving answers')
      })
      .catch(({ response }) => {
        console.log('errors while saving answers')
        console.log(response)
      });
    }
  },
  computed: {
    currentSurveyStep() {
      return this.steps[this.consentStep - 1]
    },
    isFirstStep() {
      return this.consentStep == 1
    },
    questionGroups() {
      return this.currentSurveyStep.groups
    },
    checkboxAgreement() {
      // TO DO: Change to include all question groups, not just the first
      return this.answers[0].find(a => a.question_type == 'checkbox agreement')
    },
    modalFallback() {
      if(!this.currentSurveyStep) return;

      return this.currentSurveyStep.modal_fallback
    },
    consentStepTotal() {
      return this.steps.length;
    }
  },
  created() {
    axios.get('/consent')
    .then(response => {
      this.steps = response.data.consent_steps
      this.fillAnswers()

      const currentUrl = window.location.search
      const urlParams = new URLSearchParams(currentUrl)
      const toSurveyStep = urlParams.get('surveystep')

      if (!toSurveyStep) return

      const step = parseInt(toSurveyStep)

      if (step > this.consentStepTotal) return

      this.consentStep = step
    })
    .catch(e => {
      console.log('errors while parsing steps')
      console.log(e)
    });
  },
  watch: {
    consentStep(value) {
      this.fillAnswers()
    }
  }
}
</script>

