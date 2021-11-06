
function is_one_word(word) {
    return /^[а-яa-zё]+$/i.test(word);
}

function is_letter(letter) {
    return is_russian_letter(letter.toLowerCase()) ||
            is_english_letter(letter.toLowerCase());
}

function is_russian_letter(letter) {
    return 'а' <= letter && letter <= 'я' || letter === 'ё';
}

function is_english_letter(letter) {
    return 'a' <= letter && letter <= 'z';
}
