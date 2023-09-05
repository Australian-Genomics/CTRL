<template>
  <div id="consent-form">

    <div id="modal-loading" v-if="isLoading">
      <img src="spinner.svg" />
    </div>

    <ModalFallback
      :modal="modalFallback"
      v-if="modalFallback"
    />

    <ModalServerError
      :modal="modalServerError"
      v-if="modalServerError"
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
              <h3 class="text-center mt-2 mb-15"
                v-html="currentSurveyStep.title"/>

              <div class="d-flex mb-30">
                <p class="steps__description mx-auto mb-0 text-justify"
                  v-html="currentSurveyStep.description">
                </p>
              </div>

              <div class="steps__question-image-container">
                <img
                  class="steps__question-image"
                  v-if="currentSurveyStep.description_image_url"
                  :src="currentSurveyStep.description_image_url"/>
              </div>

              <div
                v-for="(qstionGrp, qGindex) in questionGroups"
                v-bind:key="`qstionGrp-${qGindex}`"
              >
                <div class="steps__general text-center py-2 mb-30"
                  v-if="qstionGrp.header">
                  <b v-html="qstionGrp.header"/>
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
                        <label class="controls controls__checkbox controls__checkbox_blue ml-sm-15"
                          v-if="question.question_type == 'checkbox' || question.question_type == 'checkbox agreement' "
                        >
                          <input
                              v-model="answers[qGindex][i].answer"
                              type="checkbox"
                              true-value="yes"
                              false-value="no"
                          >
                          <span class="checkmark"></span>
                        </label>

                        <div
                            class="d-flex mt-3 mt-sm-0 text-capitalize"
                            v-else-if="question.question_type === 'multiple checkboxes'"
                        >
                          <span v-for="(option, oi) in question.options">
                            <label>
                              <label class="controls controls__checkbox" :class="['controls__checkbox_'+option.color.replace('#','')]">
                                <input type="checkbox"
                                       :value="option.value.toLowerCase()"
                                       :checked="isChecked(answers[qGindex][i].multiple_answers,option.value)"
                                       v-on:change="selectMultiOpt($event.target)"
                                       data-color="tab"

                                >
                                <span class="checkmark" ></span>
                                <span class="label-text ml-1 mr-1">{{ option.value }}</span>
                              </label>
                            </label>
                          </span>
                        </div>
                        <div class="d-flex mt-3 mt-sm-0 text-capitalize" v-else-if="question.question_type === 'multiple choice'">
                          <span v-for="(option, oi) in question.options">
                            <label>
                              <label class="controls controls__radio ml-sm-15" :class="['controls__radio_'+option.color.replace('#','')]">
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


                      </template>
                    </div>

                    <div class="col-12"
                      v-if="question.answer_choices_position === 'bottom'" >
                      <div class="d-flex mt-3 mt-sm-0 text-capitalize" v-if="question.question_type === 'multiple choice'">
                          <span v-for="(option, oi) in question.options">
                            <label>
                              <label class="controls controls__radio ml-sm-15" :class="['controls__radio_'+option.color.replace('#','')]">
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

                      <label class="controls controls__checkbox ml-sm-15 controls__checkbox_blue"
                             v-if="question.question_type == 'checkbox' || question.question_type == 'checkbox agreement' "
                      >
                        <input
                            v-model="answers[qGindex][i].answer"
                            type="checkbox"
                            true-value="yes"
                            false-value="no"
                        >
                        <span class="checkmark"></span>
                      </label>
                      <div
                          class="d-flex mt-3 mt-sm-0 text-capitalize"
                          v-else-if="question.question_type === 'multiple checkboxes'"
                      >
                          <span v-for="(option, oi) in question.options">
                            <label>
                              <label class="controls controls__checkbox" :class="['controls__checkbox_'+option.color.replace('#','')]">
                                <input type="checkbox"
                                       :value="option.value.toLowerCase()"
                                       :checked="isChecked(answers[qGindex][i].multiple_answers,option.value)"
                                       v-on:change="selectMultiOpt($event.target)"
                                       :data-color="option.color"

                                >
                                <span class="checkmark"></span>
                                <span class="label-text ml-1 mr-1">{{ option.value }}</span>
                              </label>
                            </label>
                          </span>
                      </div>
                    </div>
                    <div class="steps__question-image-container">
                      <img
                        class="steps__question-image"
                        v-if="question.question_image_url"
                        :src="question.question_image_url"/>
                    </div>
                    <div class="steps__row-collapse"
                      v-if="question.show_description && question.description">
                      <div class="steps__text-question">
                        <div v-html="question.description"/>
                        <div class="steps__description-image-container">
                          <img
                            class="steps__description-image"
                            v-if="question.description_image_url"
                            :src="question.description_image_url"/>
                        </div>
                      </div>
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
import ModalServerError from './components/ModalServerError'
import Checkbox from "./components/Checkbox";
import RadioButton from "./components/RadioButton";

export default {
  updated: function() {
    /* Modifying the DOM directly when using Vue.js is an anti-pattern. But
     * doing so allows administrators to copy/paste embed HTML from YouTube
     * into the admin portal without asking them to follow more complicated
     * instructions, like fishing-out the embed URL or modifying the HTML code
     * which YouTube provides.
     */
    const youtubeIframes = document.querySelectorAll(
      'iframe[title="YouTube video player"]'
    )
    youtubeIframes.forEach(function(youtubeIframe) {
      // Without this, we'd have to ask administrators to manually remove the
      // "height" and "width" attributes from YouTube's embed HTML to avoid them
      // overriding our CSS.
      youtubeIframe.removeAttribute('width')
      youtubeIframe.removeAttribute('height')

      // Each question is divided into three columns, containing the text,
      // information icon, and input elements. Without this logic, the
      // administrator would only be able to place the video in the first
      // column, making it appear squashed to one side.
      if (youtubeIframe.closest('.steps__row-main > .steps__text-question')) {
        const parentStepsRow = youtubeIframe.closest('.steps__row')
        youtubeIframe.parentElement.removeChild(youtubeIframe)
        parentStepsRow.appendChild(youtubeIframe)
      }
    })
  },
  components: {
    StepDisplayer,
    StepInitial,
    ModalFallback,
    ModalServerError,
    Checkbox,
    RadioButton
  },
  data() {
    return {
      consentStep: 1,
      steps: [],
      answers: [],
      checkedAnswers:[],
      configs: [],
      modal_server_error: null,
      isLoading: false
    }
  },
  methods: {
    setColor() {
      if (this.configs.length > 0){
        this.root = document.documentElement;
        const radioConfig = this.configs.find(conf => conf.key === "radio_button_color")
        this.root.style.setProperty("--radio-check-color", radioConfig.value)
        this.root.style.setProperty("--radio-check-border-color", radioConfig.value)
        const checkboxConfig = this.configs.find(conf => conf.key === "checkbox_color")
        this.root.style.setProperty("--checkmark-color", checkboxConfig.value)
        this.root.style.setProperty("--checkmark-border-color", checkboxConfig.value)
      }
    },
    isChecked(userAnswers, option) {
      let isChecked = userAnswers.includes(option.toLowerCase())
      return isChecked
    },
    selectMultiOpt(target){
      if (target.checked){
        this.checkedAnswers.push(target.value)

      }
      else{
        this.checkedAnswers = this.checkedAnswers.filter(item => item !== target.value)
      }
    },
    async nextStep() {
      if (!await this.showSpinner(this.saveAnswers)) {
        return;
      }

      if (this.modalFallback && !this.doesAgreeToAll()) {
        this.$modal.show('modal-fallback')
      } else {
        window.scrollTo({ top: 0 });
        this.consentStep += 1
      }
    },
    async previousStep() {
      if (!await this.showSpinner(this.saveAnswers)) {
        return;
      }
      window.scrollTo({ top: 0 });
      this.consentStep -= 1
    },
    async saveAndExit() {
      if (!await this.showSpinner(this.saveAnswers)) {
        return;
      }

      if (this.modalFallback && !this.doesAgreeToAll()) {
        this.$modal.show('modal-fallback')
      } else {
        window.location.href = '/'
      }
    },
    toggleDescription(question) {
      question.show_description = !question.show_description
    },
    fillAnswers() {
      this.answers = [];
      this.currentSurveyStep.groups.forEach((group, gIndex)  => {
        this.answers.push([])
        group.questions.forEach(question => {
          question.question_type == 'multiple checkboxes' && this.checkedAnswers.push(...(question.answer.multiple_answers ))
          this.answers[gIndex].push({
            consent_question_id: question.id,
            answer: question.answer.answer || question.default_answer,
            multiple_answers: this.checkedAnswers,
            question_type: question.question_type,
          })
        })
      })
    },
    async saveAnswers() {
      const token = document.querySelector('[name=csrf-token]').content
      axios.defaults.headers.common['X-CSRF-TOKEN'] = token

      let answersParams = []
      this.answers.forEach(answerArray => {
        answerArray.map( ans => ans.question_type==="multiple checkboxes" ? ans.multiple_answers = this.checkedAnswers : ans.multiple_answers )
        answersParams.push(...answerArray)
      })

      try {
        const { data } = await axios.put('/consent-form', {
          consent_step_id: this.currentSurveyStep.id,
          answers: answersParams
        });
        this.steps = data.consent_steps;
        console.log('success in saving answers');
      } catch ({ response }) {
        console.log('errors while saving answers');
        console.log(response);
        if (response.status >= 500 && response.status <= 599) {
          this.$modal.show('modal-server-error');
          return false;
        }
      }
      return true;
    },
    async showSpinner(callback) {
      this.isLoading = true;
      const result = await callback();
      this.isLoading = false;
      return result;
    },
    doesAgreeToAll() {
      return this.checkboxAgreementQuestions.every(
        question => question.answer != 'no');
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
    checkboxAgreementQuestions() {
      return this.answers.flatMap(
        group => group.filter(
          question => question.question_type == 'checkbox agreement'));
    },
    modalFallback() {
      if(!this.currentSurveyStep) return;

      return this.currentSurveyStep.modal_fallback
    },
    modalServerError() {
      return this.modal_server_error;
    },
    consentStepTotal() {
      return this.steps.length;
    },

  },
  created() {
    axios.get('/consent')
    .then(response => {
      this.steps = response.data.consent_steps
      this.fillAnswers()
      this.configs = [...response.data.survey_configs]
      this.modal_server_error = response.data.modal_server_error
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
      this.setColor()
    }
  }
}
</script>

