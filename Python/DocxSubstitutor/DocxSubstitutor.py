from docx import Document


class DocxSubstitutor:
    @staticmethod
    def substitute(filePath: str = "", els: [[]] = [[]]):
        doc = Document(filePath)
        for paragraph in doc.paragraphs:
            for run in paragraph.runs:
                for el in els:
                    if el[0] in run.text:
                        run.text = run.text.replace(el[0], el[1])
        doc.save(filePath)
