﻿
&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
	
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьНаСервере()
	Запрос = Новый Запрос; 
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТестОбработкиВыбора.Ссылка КАК Ссылка,
	|	ТестОбработкиВыбора.Объект КАК Объект
	|ИЗ
	|	Справочник.ТестОбработкиВыбора КАК ТестОбработкиВыбора";
	РезультатЗапроса = Запрос.Выполнить();
	НаборДанных = ОбщегоНазначенияПТБ.РезультатЗапросаВСоответствие(РезультатЗапроса, "Объект");
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИдентификаторыОбъектовМетаданных.Ссылка КАК Ссылка,
	|	ИдентификаторыОбъектовМетаданных.Родитель КАК Родитель,
	|	ИдентификаторыОбъектовМетаданных.Ссылка КАК Объект,
	|	ИдентификаторыОбъектовМетаданных.ПолноеИмя КАК ПолноеИмя,
	|	ИдентификаторыОбъектовМетаданных.ПолныйСиноним КАК ПолныйСиноним,
	|	ИдентификаторыОбъектовМетаданных.Имя КАК Имя,
	|	ИдентификаторыОбъектовМетаданных.Синоним КАК Синоним,
	|	ИдентификаторыОбъектовМетаданных.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
	|
	|УПОРЯДОЧИТЬ ПО
	|	Родитель";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеСправочника = НаборДанных.Получить(Выборка.Ссылка);
		Если ДанныеСправочника = Неопределено Тогда
			ЭлементСправочника = Справочники.ТестОбработкиВыбора.СоздатьЭлемент();
		Иначе 
			ЭлементСправочника = ДанныеСправочника.Ссылка.ПолучитьОбъект();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементСправочника, Выборка);
		
		РодительДанные = НаборДанных.Получить(Выборка.Родитель);
		Если РодительДанные <> Неопределено Тогда
			ЭлементСправочника.Родитель = РодительДанные.Ссылка;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭлементСправочника, Ложь, Ложь);
	КонецЦикла;
КонецПроцедуры
