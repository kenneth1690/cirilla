import 'package:flutter_html_form/contact_form7.dart';
import 'package:test/test.dart';

void main() {
  group('TextField', () {
    test('Single Text Field', () {
      // 1) Single Text Field required
      expect(fromContactFrom7('[text* your-name]'),
          '<input required type="text" name="your-name" />');

      // 2) Single Text Field not required
      expect(fromContactFrom7('[text your-name]'),
          '<input type="text" name="your-name" />');

      // 3) Single Text Field required wrap with div
      expect(fromContactFrom7('<div>[text* your-name]</div>'),
          '<div><input required type="text" name="your-name" /></div>');

      // 4) 2 Single Text Field required
      expect(fromContactFrom7('[text* your-name][text* your-name-2]'),
          '<input required type="text" name="your-name" /><input required type="text" name="your-name-2" />');

      // 5) Single Text Field required with 2 space before field name
      expect(fromContactFrom7('[text*  your-name-5]'),
          '<input required type="text" name="your-name-5" />');

      // 6) Single Text Field required with class
      expect(fromContactFrom7('[text* your-name-6 class:form-control]'),
          '<input required type="text" name="your-name-6" class="form-control" />');

      // 7) Single Text Field required with id
      expect(fromContactFrom7('[text* your-name-7 id:form-control]'),
          '<input required type="text" name="your-name-7" id="form-control" />');

      // 8) Single Text Field required with class and id
      expect(fromContactFrom7('[text* your-name-8 class:form-control id:form-control]'),
          '<input required type="text" name="your-name-8" class="form-control" id="form-control" />');

      // 9) Single Text Field required with minlength
      expect(fromContactFrom7('[text* your-name-9 minlength:10]'),
          '<input required type="text" name="your-name-9" minlength="10" />');

      // 10) Single Text Field required with maxlength
      expect(fromContactFrom7('[text* your-name-10 maxlength:10]'),
          '<input required type="text" name="your-name-10" maxlength="10" />');

      // 11) Single Text Field required with minlength and maxlength
      expect(fromContactFrom7('[text* your-name-11 minlength:10 maxlength:20]'),
          '<input required type="text" name="your-name-11" minlength="10" maxlength="20" />');

      // 12) Single Text Field required with size
      expect(fromContactFrom7('[text* your-name-12 size:10]'),
          '<input required type="text" name="your-name-12" size="10" />');

      // 13) Single Text Field required with placeholder
      expect(fromContactFrom7('[text* your-name-13 placeholder "Your name"]'),
          '<input required type="text" name="your-name-13" placeholder="Your name" />');

      // 14) Single Text Field required with default value
      expect(fromContactFrom7('[text* your-name-14 "Your name"]'),
          '<input required type="text" name="your-name-14" value="Your name" />');

      // 15) Single Text Field required with default value param
      expect(fromContactFrom7('[text* your-name-15 default:username]'),
          '<input required type="text" name="your-name-15" value="{{username}}" />');
      
      // 16) Single Text Field required with default value param and placeholder
      expect(fromContactFrom7('[text* your-name-16 default:username placeholder "Your name"]'),
          '<input required type="text" name="your-name-16" placeholder="Your name" value="{{username}}" />');


    });
  });

  group('EmailField', () {
    test('Single Email Field', () {
      // 1) Single Text Field required
      expect(fromContactFrom7('[email* your-name]'),
          '<input required type="email" name="your-name" />');

      // 2) Single Email Field not required
      expect(fromContactFrom7('[email your-name]'),
          '<input type="email" name="your-name" />');

      // 3) Single Email Field required wrap with div
      expect(fromContactFrom7('<div>[email* your-name]</div>'),
          '<div><input required type="email" name="your-name" /></div>');

      // 4) 2 Single Email Field required
      expect(fromContactFrom7('[email* your-name][email* your-name-2]'),
          '<input required type="email" name="your-name" /><input required type="email" name="your-name-2" />');

      // 5) Single Email Field required with 2 space before field name
      expect(fromContactFrom7('[email*  your-name-5]'),
          '<input required type="email" name="your-name-5" />');

      // 6) Single Email Field required with class
      expect(fromContactFrom7('[email* your-name-6 class:form-control]'),
          '<input required type="email" name="your-name-6" class="form-control" />');

      // 7) Single Email Field required with id
      expect(fromContactFrom7('[email* your-name-7 id:form-control]'),
          '<input required type="email" name="your-name-7" id="form-control" />');

      // 8) Single Email Field required with class and id
      expect(fromContactFrom7('[email* your-name-8 class:form-control id:form-control]'),
          '<input required type="email" name="your-name-8" class="form-control" id="form-control" />');

      // 9) Single Email Field required with minlength
      expect(fromContactFrom7('[email* your-name-9 minlength:10]'),
          '<input required type="email" name="your-name-9" minlength="10" />');

      // 10) Single Email Field required with maxlength
      expect(fromContactFrom7('[email* your-name-10 maxlength:10]'),
          '<input required type="email" name="your-name-10" maxlength="10" />');

      // 11) Single Email Field required with minlength and maxlength
      expect(fromContactFrom7('[email* your-name-11 minlength:10 maxlength:20]'),
          '<input required type="email" name="your-name-11" minlength="10" maxlength="20" />');

      // 12) Single Email Field required with size
      expect(fromContactFrom7('[email* your-name-12 size:10]'),
          '<input required type="email" name="your-name-12" size="10" />');

      // 13) Single Email Field required with placeholder
      expect(fromContactFrom7('[email* your-name-13 placeholder "Your name"]'),
          '<input required type="email" name="your-name-13" placeholder="Your name" />');

      // 14) Single Email Field required with default value
      expect(fromContactFrom7('[email* your-name-14 "Your name"]'),
          '<input required type="email" name="your-name-14" value="Your name" />');

      // 15) Single Email Field required with default value param
      expect(fromContactFrom7('[email* your-name-15 default:username]'),
          '<input required type="email" name="your-name-15" value="{{username}}" />');

      // 16) Single Email Field required with default value param and placeholder
      expect(fromContactFrom7('[email* your-name-16 default:username placeholder "Your name"]'),
          '<input required type="email" name="your-name-16" placeholder="Your name" value="{{username}}" />');


    });
  });

  group('TextareaField', () {
    test('Single Textarea Field', () {
      expect(fromContactFrom7('[textarea* your-name "Your message"]'),
          '<textarea required name="your-name">Your message</textarea>');
    });

    test('Single Textarea Field with Close tag', () {
      expect(fromContactFrom7('[textarea* your-name]Your message2[/textarea]'),
          '<textarea required name="your-name">Your message2</textarea>');
    });
  });

  group('SubmitField', () {
    test('Single Text Field', () {
      // 1) Single Submit Field
      expect(fromContactFrom7('[submit "Submit"]'),
          '<input type="submit" value="Submit" />');

      // 2) Single Submit without value
      expect(fromContactFrom7('[submit]'),
          '<input type="submit" value="Send" />');
    });
  });

  group('CheckboxesField', () {
    test('Checkboxes Field', () {
      // 1) Single Checkbox
      expect(fromContactFrom7('[checkbox vehicle "Bike"]'),
          '<div data-name="vehicle" class="checkbox"><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label></div>');

      // 2) Single Checkbox with 2 value
      expect(fromContactFrom7('[checkbox vehicle "Bike" "Car"]'),
          '<div data-name="vehicle" class="checkbox"><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label><input type="checkbox" id="vehicle-car" name="vehicle" value="Car"/><label for="vehicle-car">Car</label></div>');

      // 3) Single Checkbox default selected
      expect(fromContactFrom7('[checkbox vehicle "Bike" "Car" default:2]'),
          '<div data-name="vehicle" class="checkbox"><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label><input type="checkbox" id="vehicle-car" name="vehicle" value="Car" checked/><label for="vehicle-car">Car</label></div>');

      // 4) Single Checkbox default selected with 2 value
      expect(fromContactFrom7('[checkbox vehicle "Bike" "Car" default:1_2]'),
          '<div data-name="vehicle" class="checkbox"><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike" checked/><label for="vehicle-bike">Bike</label><input type="checkbox" id="vehicle-car" name="vehicle" value="Car" checked/><label for="vehicle-car">Car</label></div>');

      // 5) Id and class
      expect(fromContactFrom7('[checkbox vehicle "Bike" "Car" id:vehicle class:form-control]'),
          '<div data-name="vehicle" id="vehicle" class="checkbox form-control"><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label><input type="checkbox" id="vehicle-car" name="vehicle" value="Car"/><label for="vehicle-car">Car</label></div>');

      // 6) Exclusive Checkbox
      expect(fromContactFrom7('[checkbox vehicle exclusive "Bike"]'),
          '<div data-name="vehicle" class="checkbox" data-exclusive><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label></div>');
      // 7) Label first Checkbox
      expect(fromContactFrom7('[checkbox vehicle label_first "Bike"]'),
          '<div data-name="vehicle" class="checkbox" data-labelfirst><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label></div>');
      // 8) Required Checkbox
      expect(fromContactFrom7('[checkbox* vehicle "Bike"]'),
          '<div data-name="vehicle" class="checkbox" data-required><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label></div>');
      // 9) Images Checkbox
      expect(fromContactFrom7('[checkbox vehicle images:url1|url2 "Bike" "Car"]'),
          '<div data-name="vehicle" class="checkbox"><input type="checkbox" id="vehicle-bike" name="vehicle" value="Bike" src="url1"/><label for="vehicle-bike">Bike</label><input type="checkbox" id="vehicle-car" name="vehicle" value="Car" src="url2"/><label for="vehicle-car">Car</label></div>');
    });
  });

  group('RadioField', () {
    test('Radio Field', () {
      // 1) Single Checkbox
      expect(fromContactFrom7('[radio vehicle "Bike"]'),
          '<div data-name="vehicle" class="radio"><input type="radio" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label></div>');

      // 2) Single Checkbox with 2 value
      expect(fromContactFrom7('[radio vehicle "Bike" "Car"]'),
          '<div data-name="vehicle" class="radio"><input type="radio" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label><input type="radio" id="vehicle-car" name="vehicle" value="Car"/><label for="vehicle-car">Car</label></div>');

      // 3) Single Checkbox default selected
      expect(fromContactFrom7('[radio vehicle "Bike" "Car" default:2]'),
          '<div data-name="vehicle" class="radio"><input type="radio" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label><input type="radio" id="vehicle-car" name="vehicle" value="Car" checked/><label for="vehicle-car">Car</label></div>');

      // 4) Single Checkbox default selected with 2 value
      expect(fromContactFrom7('[radio vehicle "Bike" "Car" default:1_2]'),
          '<div data-name="vehicle" class="radio"><input type="radio" id="vehicle-bike" name="vehicle" value="Bike" checked/><label for="vehicle-bike">Bike</label><input type="radio" id="vehicle-car" name="vehicle" value="Car" checked/><label for="vehicle-car">Car</label></div>');

      // 5) Id and class
      expect(fromContactFrom7('[radio vehicle "Bike" "Car" id:vehicle class:form-control]'),
          '<div data-name="vehicle" id="vehicle" class="radio form-control"><input type="radio" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label><input type="radio" id="vehicle-car" name="vehicle" value="Car"/><label for="vehicle-car">Car</label></div>');
      // 7) Label first Radio
      expect(fromContactFrom7('[radio vehicle label_first "Bike"]'),
          '<div data-name="vehicle" class="radio" data-labelfirst><input type="radio" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label></div>');
      // 8) Required radio
      expect(fromContactFrom7('[radio* vehicle "Bike"]'),
          '<div data-name="vehicle" class="radio" data-required><input type="radio" id="vehicle-bike" name="vehicle" value="Bike"/><label for="vehicle-bike">Bike</label></div>');
      // 9) Images radio
      expect(fromContactFrom7('[radio vehicle images:url1|url2 "Bike" "Car"]'),
          '<div data-name="vehicle" class="radio"><input type="radio" id="vehicle-bike" name="vehicle" value="Bike" src="url1"/><label for="vehicle-bike">Bike</label><input type="radio" id="vehicle-car" name="vehicle" value="Car" src="url2"/><label for="vehicle-car">Car</label></div>');
    });
  });

  group('SelectField', () {
    test('Select Field', () {
      // 1) Single Select
      expect(fromContactFrom7('[select vehicle "Bike"]'),
          '<select name="vehicle"><option value="Bike">Bike</option></select>');

      // 2) Single Select with 2 value
      expect(fromContactFrom7('[select vehicle "Bike" "Car"]'),
          '<select name="vehicle"><option value="Bike">Bike</option><option value="Car">Car</option></select>');

      // 3) Single Select default selected
      expect(fromContactFrom7('[select vehicle "Bike" "Car" default:2]'),
          '<select name="vehicle"><option value="Bike">Bike</option><option value="Car" selected>Car</option></select>');

      // 4) Single Select default selected with 2 value
      expect(fromContactFrom7('[select vehicle "Bike" "Car" default:1_2]'),
          '<select name="vehicle"><option value="Bike" selected>Bike</option><option value="Car" selected>Car</option></select>');

      // 5) Id and class
      expect(fromContactFrom7('[select vehicle "Bike" "Car" id:vehicle class:form-control]'),
          '<select name="vehicle" id="vehicle" class="form-control"><option value="Bike">Bike</option><option value="Car">Car</option></select>');
      // 7) Multiple Select
      expect(fromContactFrom7('[select vehicle multiple "Bike" "Car"]'),
          '<select name="vehicle" multiple><option value="Bike">Bike</option><option value="Car">Car</option></select>');
      // 8) Insert a blank item as the first option - Select
      expect(fromContactFrom7('[select vehicle include_blank "Bike" "Car"]'),
          '<select name="vehicle" data-includeblank><option value="Bike">Bike</option><option value="Car">Car</option></select>');
      // 9) Required Select
      expect(fromContactFrom7('[select* vehicle "Bike"]'),
          '<select name="vehicle" required><option value="Bike">Bike</option></select>');
    });
  });

  group('AcceptanceField', () {
    test('Acceptance Field', () {
      // 1) Acceptance without condition
      expect(fromContactFrom7('[acceptance acceptance-366]'),
          '<div data-name="acceptance-366" class="acceptance"></div>');

      // 2) Acceptance with condition
      expect(fromContactFrom7('[acceptance acceptance-366]Condition[/acceptance]'),
          '<div data-name="acceptance-366" class="acceptance" data-condition="Condition"></div>');

      // 3) Acceptance default true
      expect(fromContactFrom7('[acceptance acceptance-366 default:on]Condition[/acceptance]'),
          '<div data-name="acceptance-366" class="acceptance" data-active data-condition="Condition"></div>');

      // 4) Acceptance invert
      expect(fromContactFrom7('[acceptance acceptance-366 default:on invert]Condition[/acceptance]'),
          '<div data-name="acceptance-366" class="acceptance" data-active data-condition="Condition" data-invert></div>');

      // 5) Id and class
      expect(fromContactFrom7('[acceptance acceptance-366 id:acceptance class:form-control]Condition[/acceptance]'),
          '<div data-name="acceptance-366" id="acceptance" class="acceptance form-control" data-condition="Condition"></div>');
      // 6) Required
      expect(fromContactFrom7('[acceptance* acceptance-366]Condition[/acceptance]'),
          '<div data-name="acceptance-366" class="acceptance" data-required data-condition="Condition"></div>');
    });
  });

  group('QuizField', () {
    test('Quiz Field', () {
      // 1) Quiz single
      expect(fromContactFrom7('[quiz quiz-837 "one?|1"]'),
          '<div data-name="quiz-837" class="quiz"><span data-name="quiz-837">one?|1</span></div>');

      // 2) Quiz multi
      expect(fromContactFrom7('[quiz quiz-837 "one?|1" "two?|2" "three?|3"]'),
          '<div data-name="quiz-837" class="quiz"><span data-name="quiz-837">one?|1</span><span data-name="quiz-837">two?|2</span><span data-name="quiz-837">three?|3</span></div>');

      // 3) Quiz required
      expect(fromContactFrom7('[quiz* quiz-837 "one?|1" "two?|2" "three?|3"]'),
          '<div data-name="quiz-837" class="quiz" data-required><span data-name="quiz-837">one?|1</span><span data-name="quiz-837">two?|2</span><span data-name="quiz-837">three?|3</span></div>');

      // 4) Id and class
      expect(fromContactFrom7('[quiz quiz-837 id:quiz class:form-control "one?|1" "two?|2" "three?|3"]'),
          '<div data-name="quiz-837" id="quiz" class="quiz form-control"><span data-name="quiz-837">one?|1</span><span data-name="quiz-837">two?|2</span><span data-name="quiz-837">three?|3</span></div>');

      // 5) Min/max length and size
      expect(fromContactFrom7('[quiz quiz-837 minlength:4 maxlength:20 size:600 "one?|1" "two?|2" "three?|3"]'),
          '<div data-name="quiz-837" class="quiz" data-minlength="4" data-maxlength="20" data-size="600"><span data-name="quiz-837">one?|1</span><span data-name="quiz-837">two?|2</span><span data-name="quiz-837">three?|3</span></div>');
    });
  });
}
