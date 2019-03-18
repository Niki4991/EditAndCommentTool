# EditAndCommentTool
A comment tool to explain a note in both drawing and text format. Here screen is captured and user is allowed to edit with his/her thoughts, queries in drawing or text format. Multiple colours are provided to draw. Text in bold, italic, normal, adjusting font size, different font color, background color. Also settings is added to adjust color, opacity and bush width. Text can be draggable and editable. After all the changes, image can be shared and saved.

# screenshot
![Simulator Screen Shot - iPhone 6 Plus - 2019-03-18 at 17 33 40](https://user-images.githubusercontent.com/16645242/54528945-84069980-49a4-11e9-9db6-e1973850b042.png)
![Simulator Screen Shot - iPhone 6 Plus - 2019-03-18 at 17 33 48](https://user-images.githubusercontent.com/16645242/54528953-8963e400-49a4-11e9-9b25-84902dc0023c.png)
![Simulator Screen Shot - iPhone 6 Plus - 2019-03-18 at 17 34 14](https://user-images.githubusercontent.com/16645242/54528956-8b2da780-49a4-11e9-8ac9-95947a8e0f4f.png)
![Simulator Screen Shot - iPhone 6 Plus - 2019-03-18 at 17 34 20](https://user-images.githubusercontent.com/16645242/54528959-8d900180-49a4-11e9-8289-09262c316c66.png)


# Compatability
Version - Swift 4.2+, iOS 10+
# Example
```
let annotation_VC = storyboard?.instantiateViewController(withIdentifier: "AnnotationDisplayViewController") as? AnnotationDisplayViewController
annotation_VC?.modalPresentationStyle = .overCurrentContext
self.present(annotation_VC!, animated: true, completion: nil)
```
Add these above lines to capture and navigate to annotation mode.
