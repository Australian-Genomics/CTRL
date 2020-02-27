QUS = {
    step_two_questions:
        [{question_id: 1, qus: 'I understand I am providing a sample so that my DNA can be extracted and all of my genes could be looked at. This is called a genomic test.', description: 'The sample you have given may have been blood, saliva, skin or other sample already collected as part of your medical care. These samples contain your cells, and your DNA can be extracted from the cells. Your DNA is needed for the genomic test. DNA makes up genes. Genes are inside almost every cell of your body. There are over 20,000 genes in each of your cells, and together these genes make up your “genome”.  Each gene has a specific function, however the function of every gene is not yet known. Everyone has different variations within their genes, which is why we are all unique. Most variations are harmless, but other variations can change how a gene works, which might cause a health condition. Identifying variations may help to find the cause of your health condition. Previously, testing to look for variations in genes involved looking at only one gene at a time. New technology means we can now look at many or all of our genes at once. This is known as “genomic testing”.', default_value: true},
         {question_id: 2, qus: 'I understand having a genomic test may not find the genetic cause of my condition. ', description: 'The likelihood of finding a genetic cause depends on a number of things, including your health condition and how much is already known about it. We are still learning about what genes do and how they work. Between 30 and 50% of patients with rare disease receive a diagnosis through genomic testing. That is, 3 to 5 people in every 10 tested will receive a genetic explanation for their condition. We expect more patients will receive a diagnosis in the future, as the technology and our ability to interpret genomic information improve.', default_value: true},
         {question_id: 3, qus: 'I understand my sample and genomic information will be stored by the testing laboratory so that it could be looked at again in the future, when we know more about genes that cause my health condition.', description: 'Your sample will be stored in the laboratory for at least 3 months. Depending on the laboratory and the law, it may be stored many years after this. The laboratory will also keep the genomic information they obtain from your sample. This allows for future re-analysis (looking at your genomic information again) if there is a specific reason or request to do so. For example, this might be done if new gene variants linked with your health condition are identified.', default_value: true},
         {question_id: 4, qus: 'I understand my genomic test results are confidential and will only be shared with the medical team directly involved in my care.', description: 'This could include your Clinical Geneticist and other specialist doctors, your Genetic Counsellor or your GP. Agreeing to participate in the Australian Genomics research means your results will be shared with relevant investigators on the study. Your result may be included in your My Health Record, if you have one.', default_value: true},
         {question_id: 5, qus: 'I understand that the testing laboratory could share my anonymous genomic information with other laboratories, in order to understand more about the genetic changes that can cause my health condition or other conditions.', description: 'Anonymous means that your personal details have been removed, so it cannot be easily identified as yours. This kind of sharing is done to benefit research, but means that you will probably not personally benefit from anything that is discovered from sharing your information.', default_value: true},
         {question_id: 6, qus: 'I understand the laboratory performing my test will store and may sometimes use my DNA sample for purposes like reference and control material.', description: 'Your DNA is stored in the testing laboratory for at least three months, but it could be years. When doing any laboratory test, it is important to compare the test sample with a control sample. Your DNA may be used as a control sample. All of your personal, identifying information will be removed if your sample is used for this purpose.', default_value: true},
         {question_id: 7, qus: 'I understand there are certain risks involved in having a genomic test. These could include finding out something that may be important for my family’s health, incidental findings, or having to disclose the genomic information.', description: 'The main risks involved in having a genomic test are related to the information that you may get, rather than any physical harm. For example: <ul><li>Waiting for the test results, or the results you receive, may bring up a number of different emotions.</li><li>We may be uncertain about what your result means.</li><li>It may be uncomfortable or stressful to share a result with your family.</li><li>The test may find something important to your health that you or the doctors were not expecting. This is called an incidental finding. You will be given the opportunity to give your preferences about incidental findings in step 4.</li><li>You may have to disclose the information to insurance companies or employers. There is more information on this in the next question.</li></ul>', default_value: true},
         {question_id: 8, qus: 'I understand that if I am taking out a new policy for life, critical illness or income protection insurance, the insurer may ask me to disclose that I have had a genetic test and require me to provide my results.', description: 'How insurance companies use personal genetic information is currently being investigated by government. If you would like more information about the impact of genetic testing on certain insurance products, visit the Centre for Genetics Education <a href="http://www.genetics.edu.au/publications-and-resources/facts-sheets/fact-sheet-20-life-insurance-products-and-genetic-testing-in-australia" target="_blank">insurance fact sheet.</a>', default_value: true},
         {question_id: 9, qus: 'I understand my employer, or future employers, may ask for my results to decide whether there is a risk associated with a particular job role.', description: "The law allows an employer to ask for your health details, including genetic testing results, if they think it is relevant in deciding whether you are able to fulfil a job role. In reality, very few employers do ask for your genetic testing results, but it's important that you know it may become more relevant in the future.", default_value: true},
         {question_id: 10, qus: 'I understand that it might be important to tell my family members about genetic changes that could directly affect their health. My medical team will support me in sharing such information with my family.', description: "Family members who may have an interest in knowing about your result are your biological, or blood relatives. These people include your parents, children, aunts, uncles and cousins. If you are planning to have (more) children your partner may need to know. Exactly who needs to know is different on a case by case basis. Your medical team will support you in sharing information with family members.", default_value: true},
         {question_id: 11, qus: 'I understand all of the information above and the choices I have made.</br>(leaving this box unchecked means you will be contacted by a Genetic Counsellor who will give you more information)', description: '', default_value: false},
        ],

    step_three_questions:
        [{question_id: 12, qus: 'I understand that the researchers will collect information from my medical records.', description: 'We will ask the Commonwealth Department of Health for your Medicare (MBS) and Pharmacy (PBS) records, covering a period of up to 8 years. We will ask Data Linkage agencies in each State or Territory of Australia for your hospital inpatient records and emergency department visit records. This information will cover a period of up to 14 years. This information will be very important for us to understand how having a genomic test and a genomic diagnosis might reduce the long-term costs of health care. Access to the information is tightly regulated to protect your privacy, and we only receive it after applying for it through the proper channels. We will also be required to destroy it after we finish using it.',default_value: true},
         {question_id: 13, qus: 'I understand that at times during the research project I will be asked to complete surveys or questionnaires. I’ll be reminded when they are ready to complete and I can ask for help to do them.', description: 'The surveys and questionnaires will help us understand your views and your understanding of genomic testing, as well as your personal experiences of the test. We will sometimes ask you questions about the financial costs of clinic visits or having your specific health condition.',default_value: true},
         {question_id: 14, qus: 'I understand that my samples and data may be used in further research when no cause is found as part of the initial test and/or when further investigation is required to understand my condition.', description: 'Your samples and/or data will only be shared for further research that follows the relevant privacy and security requirements, and ethical guidelines for biomedical and health research. Your data and samples will be shared without any personal information (eg name), however they will be coded so if needed they can be linked back to you. We may be able to report back to you if research findings could increase your understanding of your health condition or change your clinical care. Not everyone who does not get a result from the initial testing will have their samples or information shared for further research. This will depend on whether there is a suitable research program available to look further into your initial testing results and/or health condition.',default_value: true},
         {question_id: 15, qus: 'I understand all of the information above and the choices I have made.</br>(leaving this box unchecked means you will be contacted by a Genetic Counsellor who will give you more information)', description: '',default_value: false},
        ],

    step_four_questions:
        [{question_id: 16, qus: 'I want to know about the genetic change if it is medically actionable (can alter my health management or treatment).', description: 'For example, there are some types of cancers that run in families. Sometimes we can find a genetic change that means a family is more likely to develop a cancer throughout their lifetime. If this genetic change is medically actionable, it means these families can reduce that risk through closer surveillance or surgical options.',default_value: 'not_sure'},
         {question_id: 17, qus: 'I want to know about the genetic change if it is non-medically actionable (will not alter my health management or treatment).', description: 'There are some conditions that run in families and have a genetic cause, but cannot be treated at this time. An example of this is early onset Alzheimer’s disease. This type of result would mean that you know that you are at risk of developing this condition, but at this time your health management or treatment would not change.',default_value: 'not_sure'},
         {question_id: 18, qus: 'I want to know if I am a carrier of a genetic change that can cause disease (it might affect decisions I make about having children, or for my grandchildren).', description: ' Sometimes we can be “carriers” of genetic changes that do not affect our health but can cause problems when we have a baby with a partner who also carries that same genetic change. An example of this is cystic fibrosis.',default_value: 'not_sure'},
         {question_id: 19, qus: 'I’d like my medical team and the testing laboratory to decide whether I should be told about medically actionable, non-medically actionable and carrier status findings on a case by case basis.', description: '',default_value: 'not_sure'},
         {question_id: 20, qus: 'I would like a summary of the main findings of my genomic testing report securely stored in CTRL, so I can access it at any time.', description: 'We are developing ways of showing your genomic results in a way that is understandable to you, your family and anyone else you would like to show them to. We will make this available to you as soon as it is ready, if you indicate that you would like to have it.',default_value: 'not_sure'},
         {question_id: 21, qus: 'I understand all of the information above and the choices I have made.</br>(leaving this box unchecked means you will be contacted by a Genetic Counsellor who will give you more information)', description: '',default_value: false},
        ],

    step_five_questions:
        [{question_id: 22, qus: 'Not-for-profit research organisations	 (eg Murdoch Children’s Research Institute)', description: '',default_value: 'not_sure'},
         {question_id: 23, qus: 'Universities and research institutes (eg The University of Queensland)', description: '',default_value: 'not_sure'},
         {question_id: 24, qus: 'Government (eg Australian Government Department of Health)', description: '',default_value: 'not_sure'},
         {question_id: 25, qus: 'Commercial companies (eg pharmaceutical companies)', description: '',default_value: 'not_sure'},
         {question_id: 26, qus: 'General research use and clinical care', description: 'General research use and clinical care refers to research where, for example, your genomic information might be shared through clinical networks internationally to see if there are any other cases in the world like yours. This is for clinical benefit, but because of the close links between clinical and research genomics, your genomic and other health information will likely also be used in a research setting.',default_value: 'not_sure'},
         {question_id: 27, qus: 'Health/medical/biomedical research	', description: 'Health, medical and biomedical research could include research into understanding how a genetic change affects the functioning of a tissue or organ or whole-body system. It is often done in a research laboratory setting.',default_value: 'not_sure'},
         {question_id: 28, qus: 'Research must be specifically related to my condition', description: 'Your genomic information may be helpful to study other health conditions, but if you prefer, we can restrict sharing your information to research into your condition only.',default_value: 'not_sure'},
         {question_id: 29, qus: 'Population and ancestry research', description: 'Population and ancestry research may include working out how or when a certain genetic change arose in a population, studying traits of certain populations. Your information may be grouped with many other people’s information to be part of a control or reference dataset. This helps us to understand normal genetic variation in populations.',default_value: 'not_sure'},
         {question_id: 30, qus: 'I agree to my general health information (eg just my MRIs, blood test or other results) being shared with other research studies that don’t need my genomic information.', description: '',default_value: 'not_sure'},
         {question_id: 31, qus: 'I agree to my self-reported information (eg questionnaire responses) being shared with other research studies that don’t need my genomic information.', description: '',default_value: 'not_sure'},
         {question_id: 32, qus: 'I want to be contacted every time my de-identified DNA sample, genomic, health or self-reported information is shared.', description: '',default_value: 'not_sure'},
         {question_id: 33, qus: 'I agree to Australian Genomics sharing my contact details with other research projects and clinical trials doing studies I am eligible for.', description: '',default_value: false},
         {question_id: 34, qus: 'I understand all of the information above and the choices I have made.</br>(leaving this box unchecked means you will be contacted by a Genetic Counsellor who will give you more information)', description: '',default_value: false},
        ]

}

# This Hash contains question_id and their correspond Redcap codebook field name
# Like 16 => 'ctrl_pref_result1'

QUESTIONS_REDCAP_FIELDS_HASH = {
    16 => 'ctrl_pref_result1',
    17 => 'ctrl_pref_result2',
    18 => 'ctrl_pref_result3',
    19 => 'ctrl_pref_result4',
    20 => 'ctrl_pref_result5'
}