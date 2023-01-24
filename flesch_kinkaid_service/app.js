const express = require('express')
const app = express()
const port = 3000

app.use(express.json());

app.post('/', (req, res) => {
    const text = req.body.text
    console.log(req.body)
    const fk = FleschKincaid(text)
    res.json({fk: fk})
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})


function countSyllables(word) {
    word = word.toLowerCase();
    if (word.length <= 3) { return 1; }
    word = word.replace(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '');
    word = word.replace(/^y/, '');
    try {
        return word.match(/[aeiouy]{1,2}/g).length;
    } catch (e) {
        return 0;
    }
}

// Flesch-Kincaid reading ease score interpretation:
// 100 - 90 |          5th grade | Very easy to read. Easily understood by an average 11-year-old student.
//  90 - 80 |          6th grade | Easy to read. Conversational English for consumers.
//  80 - 70 |          7th grade | Fairly easy to read.
//  70 - 60 |    8th & 9th grade | Plain English. Easily understood by 13- to 15-year-old students.
//  60 - 50 | 10th to 12th grade | Fairly difficult to read.
//  50 - 30 |            College | Difficult to read.
//  30 - 10 |   College graduate | Very difficult to read. Best understood by university graduates.
//  10 - 0 |       Professional | Extremely difficult to read. Best understood by university graduates.
function FleschKincaid(text) {
    var sentences = text.split(/[.?!]+/);
    var words = text.split(/\s+/);
    var syllables = 0;
    for (var i = 0; i < words.length; i++) {
        syllables += countSyllables(words[i]);
    }
    var score = 206.835 - 1.015 * (words.length / sentences.length) - 84.6 * (syllables / words.length);
    if (score > 100) score = 100;
    if (score < 0) score = 0;
    return score;
}