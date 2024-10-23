class Question {
  final int id, answer;
  final String question;
  final List<String> options;

  Question({ this.id,  this.question,  this.answer,  this.options});
}

const List sample_data = [
  {
    "id": 1,
    "question":
    "اللاعب محمد صلاح جزائري الجنسية؟",
    "options": ['صواب', 'خطأ'],
    "answer_index": 1,
  },
  {
    "id": 2,
    "question": "لعمل هاشتاك يجب البدء بالعلامة؟",
    "options": ['@', '.', '#', '!'],
    "answer_index": 2,
  },
  {
    "id": 3,
    "question": "أكمل المقولة التالية : كلام الليل يمحوه ....؟",
    "options": ['الممحاة', 'القلم', 'النهار', 'الهواء'],
    "answer_index": 2,
  },
  {
    "id": 4,
    "question": "الدبور يفرز حرير؟",
    "options": ['صواب', 'خطأ'],
    "answer_index": 1,
  },
  {
    "id": 5,
    "question": "لطيفة مغنية مغربية؟",
    "options": ['صواب', 'خطأ'],
    "answer_index": 1,
  },
  {
    "id": 6,
    "question": "تم بناء قصر فرساي في عام 1624؟",
    "options": ['صواب', 'خطأ'],
    "answer_index": 0,
  },
  {
    "id": 7,
    "question": "أفضل هداف في تاريخ الدوري الإنكليزي هو الان شيرار؟",
    "options": ['صواب', 'خطأ'],
    "answer_index": 0,
  },
  {
    "id": 8,
    "question": "لقب فرعون الأمة لقب أطلق على ......؟",
    "options": ['عمرو بن هاشم', 'أبو جهل', 'بن أبي كعب', 'أبو لؤلؤة المجوسي'],
    "answer_index": 1,
  },
  {
    "id": 9,
    "question": "في السنة الثالثة للهجرة فرض الله الصيام؟",
    "options": ['صواب', 'خطأ'],
    "answer_index": 1,
  },
  {
    "id": 10,
    "question": "شيرين عبد الوهاب فنانة مصرية؟",
    "options": ['صواب', 'خطأ'],
    "answer_index": 0,
  },
  // {
  //   "id": 11,
  //   "question": "ينتجه النحل وله مذاق حلو ويستخدم في العلاج؟",
  //   "options": ['فجل', 'بصل', 'عسل', 'رمل'],
  //   "answer_index": 2,
  // },
];