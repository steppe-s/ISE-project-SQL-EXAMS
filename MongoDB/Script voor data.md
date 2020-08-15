# Script voor data
Het volgende script is gebruikt om de data te genereren via https://next.json-generator.com/

```json
[
  {
    'repeat(100)': {
      _id: '{{objectId()}}',
      exam_id: '{{random("DB-1", "DB-2", "DB-3")}}',
      student: {
      	student_no: '{{integer(1, 30)}}',
        exam_group_type: '{{random("Standaard", "Dyslexie", "Herkanser")}}',
        class: '{{random("ISE-A", "ISE-B")}}',
        result: '{{integer(1, 10)}}',
        hand_in_date: '{{moment(this.date(new Date(2014, 0, 1), new Date())).format()}}',
        answer: [
          {
          	'repeat(5)': {
            	answer_status: '{{random("INCORRECT", "CORRECT")}}',
              answer_fill_in_date: '{{moment(this.date(new Date(2014, 0, 1), new Date())).format()}}',
              question_no: '{{index()+1}}'
            }
          }
        ]
      }
    }
  }
]
```