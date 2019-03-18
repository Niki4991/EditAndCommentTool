# EditAndCommentTool
A comment tool to explain a note in both drawing and text format. Here screen is captured and user is allowed to edit with his/her thoughts, queries in drawing or text format. Multiple colours are provided to draw. Text in bold, italic, normal, adjusting font size, different font color, background color. Also settings is added to adjust color, opacity and bush width. Text can be draggable and editable. After all the changes, image can be shared and saved.


# Compatability
Version - Swift 4.2+, iOS 10+
# Example
```
let annotation_VC = storyboard?.instantiateViewController(withIdentifier: "AnnotationDisplayViewController") as? AnnotationDisplayViewController
annotation_VC?.modalPresentationStyle = .overCurrentContext
self.present(annotation_VC!, animated: true, completion: nil)
```
Add these above lines to capture and navigate to annotation mode.
