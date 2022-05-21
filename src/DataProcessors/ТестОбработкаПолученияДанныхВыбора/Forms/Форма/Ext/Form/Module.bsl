﻿
&НаКлиенте
Процедура ИспользоватьИмяПриИзменении(Элемент)
	УстановитьНастройкиПоляПоискаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	УстановитьНастройкиПоляПоискаНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьНастройкиПоляПоискаНаСервере();
КонецПроцедуры

&НаСервере 
Процедура УстановитьНастройкиПоляПоискаНаСервере()
	СвязиПараметров = Новый Массив;
	Если ЗначениеЗаполнено(ЭтотОбъект.Родитель) Тогда
		СвязиПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Родитель", "Родитель"));
	КонецЕсли;
	
	ПараметрыВыбора = Новый Массив;
	Если ЭтотОбъект.ИспользоватьИмя Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("ИспользоватьИмя", Истина));
	Иначе 
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("ИспользоватьСиноним", Истина));
	КонецЕсли;
	
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("РежимОтладки", ЭтотОбъект.РежимОтладки));
	
	Элементы.Ссылка.СвязиПараметровВыбора	= Новый ФиксированныйМассив(СвязиПараметров);
	Элементы.Ссылка.ПараметрыВыбора			= Новый ФиксированныйМассив(ПараметрыВыбора);
КонецПроцедуры
