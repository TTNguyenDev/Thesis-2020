# import the fuzzywuzzy module
from fuzzywuzzy import fuzz
import re
# spellcheck main class
class SpellCheck:

    # initialization method
    def __init__(self, word_dict_file=None):
        # open the dictionary file
        self.file = open(word_dict_file, 'r')
        
        # load the file data in a variable
        data = self.file.readlines()
        
        # store all the words in a list
        # data = data.split("")
        
        # change all the words to lowercase
        for i in data:
            i.lower()
            i.rstrip()
        data = [i.lower() for i in data]
        data = [i.rstrip() for i in data]
        
        # remove all the duplicates in the list
        data = set(data)
        
        # store all the words into a class variable dictionary
        self.dictionary = list(data)

    # string setter method
    def check(self, string_to_check):
        # store the string to be checked in a class variable
        
        self.string_to_check = self.dePunc(string_to_check.lower())
        # self.dePunc(string_to_check.lower())

    # this method returns the possible suggestions of the correct words
    def suggestions(self):
        # store the words of the string to be checked in a list by using a split function
        string_words = self.string_to_check.split()

        # a list to store all the possible suggestions
        suggestions = []

        # loop over the number of words in the string to be checked
        for i in range(len(string_words)):
            
            # loop over words in the dictionary
            for name in self.dictionary:
                
                # if the fuzzywuzzy returns the matched value greater than 80
                if fuzz.ratio(string_words[i].lower(), name.lower()) >= 75:
                    print('confidence: ' + str(fuzz.ratio(string_words[i].lower(), name.lower())))
                    # append the dict word to the suggestion list
                    suggestions.append(name)

        # return the suggestions list
        return suggestions

    # this method returns the corrected string of the given input
    def correct(self):
        # store the words of the string to be checked in a list by using a split function
        
        string_words = self.preproccess_string(self.string_to_check)
        string_len = 0

        correction_count = 0.0  
        # loop over the number of words in the string to be checked
        for i in range(len(string_words)):
            
            # initiaze a maximum probability variable to 0
            max_percent = 0
            temp_name = ""
            ignore_symbol = ['mg', 'ml']
            if string_words[i].isalpha() and (string_words[i] not in ignore_symbol):
                string_len += 1
            # loop over the words in the dictionary
                for name in self.dictionary:
                    
                    # calulcate the match probability
            
                    percent = fuzz.ratio(string_words[i].lower(), name.lower())
                    
                    # if the fuzzywuzzy returns the matched value greater than 80
                    if percent >= 75:
                      
                        # if the matched probability is
                        if percent > max_percent:
                            correction_count += 1
                            temp_name = name
                            max_percent = percent
                        # print(string_words[i], name, max_percent)
                      # change the max percent to the current matched percent
            if (max_percent >= 75):
                string_words[i] = temp_name
        
        # return the cprrected string
        if string_len != 0:
          return " ".join(string_words), (correction_count / float(string_len))
        else:
          return '', 0.0

    def isMedicine(self):
        result, score = self.correct()
        if score >= 0.5:
            return True, result
        # elif score >= 0.25:
        #     return True, 'need to check: ' + result
        else:
            return False, ''
    
    def dePunc(self, string):
        tmp = ''
        for text in string:
            if text in 'aáàảãạăắằẳẵặâấầẩẫậ':
                tmp += 'a'
            elif text in 'eéèẻẽẹêếềểễệ':
                tmp += 'e'
            elif text in 'iíìỉĩị':
                tmp += 'i'
            elif text in 'IÍÌỈĨỊ':
                tmp += 'I'
            elif text in 'yýỳỷỹỵ':
                tmp += 'y'
            elif text in 'AÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬ':
                tmp += 'A'
            elif text in 'EÉÈẺẼẸÊẾỀỂỄỆ':
                tmp += 'E'
            elif text in 'OÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢ':
                tmp += 'O'
            elif text in 'oóòỏõọôốồổỗộơớờởỡợ':
                tmp += 'o'
            elif text in 'UÚÙỦŨỤƯỨỪỬỮỰ':
                tmp += 'U'
            elif text in 'uúùủũụưứừửữự':
                tmp += 'u'
            elif text in 'YÝỲỶỸỴ':
                tmp += 'Y'
            elif text in 'dđ':
                tmp += 'd'
            elif text in 'DĐ':
                tmp += 'D'
            # elif text in 'S00':
            #     tmp += '500'
            elif text in '(':
                tmp += ' ('
            elif text in ')':
                tmp +=  ') '
            elif text in '/':
                tmp += ' / '
            else:
                tmp += text
        if tmp[-1] == ' ':
            tmp = tmp[:-1]
        return tmp
    def preproccess_string(self, text):
      res = re.sub('[^A-Za-z0-9]+', ' ', text.lower())
      res = [x.strip() for x in res.split(',')]
      res = "".join(res)
      res = res.strip()
      return list(res.split(" "))
