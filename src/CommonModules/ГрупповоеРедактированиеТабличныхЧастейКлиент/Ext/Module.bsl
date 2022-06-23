﻿#Область ПрограммныйИнтерфейс

// Открывает форму "Обработки.ГрупповоеРедактированиеТабличныхЧастейПТБ.Форма" с передачей в нее параметров о текущей таблице формы, выделенных в ней строках и колонках в которых возможно групповое редактирование строк.
//
// Параметры:
//	Форма	- УправляемаяФорма - произвольная форма справочника, документа, обработки, содержащая таблицы формы.
//ВНИМАНИЕ! Для формы обязательна инициализация реквизита "_Служебный_ОписаниеТаблицДляГрупповогоРедактирования_" 
//Подробнее в описании процедуры ГрупповоеРедактированиеТабличныхЧастейСервер.СформироватьОписаниеТаблицДляГрупповогоРедактирования()
//
Процедура ОткрытьФормуЗаполненияВыделенныхСтрок(Форма) Экспорт

	ТекущаяТаблицаФормы = Форма.ТекущийЭлемент;
	
	Если ТипЗнч(ТекущаяТаблицаФормы) <> Тип("ТаблицаФормы") Тогда
		Возврат;
	КонецЕсли; 

	ИмяРеквизитаОписаниеТаблицФормы = ГрупповоеРедактированиеТабличныхЧастейКлиентСервер.ИмяРеквизитаНастроекГрупповогоРедактирования();

	Если ТипЗнч(Форма[ИмяРеквизитаОписаниеТаблицФормы]) <> Тип("ФиксированноеСоответствие") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Ошибка инициализации реквизита формы ""%1""'"), ИмяРеквизитаОписаниеТаблицФормы));
		Возврат;
	КонецЕсли; 
	
	ИмяТекущейТаблицы = ТекущаяТаблицаФормы.Имя;
	
	ОписаниеТекущейТаблицы = Форма[ИмяРеквизитаОписаниеТаблицФормы].Получить(ИмяТекущейТаблицы);
	Если ТипЗнч(ОписаниеТекущейТаблицы) <> Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для данной табличной части групповое редактирование строк запрещено'"));
		Возврат;
	КонецЕсли; 
	
	Если ТипЗнч(ОписаниеТекущейТаблицы) <> Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(НСтр("ru = 'Ошибка инициализации реквизита формы ""%1""'"), ИмяРеквизитаОписаниеТаблицФормы));
		Возврат;
	КонецЕсли; 
	
	ТаблицаИмяЭлемента	= ОписаниеТекущейТаблицы.ТаблицаИмяЭлемента;
	ТаблицаПутьКДанным	= ОписаниеТекущейТаблицы.ТаблицаПутьКДанным;
	ОписаниеКолонок		= ОписаниеТекущейТаблицы.ОписаниеКолонок;
	
	Если Не ЗначениеЗаполнено(ОписаниеКолонок) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет доступных колонок для группового редактирования строк'"));
		Возврат;
	КонецЕсли; 

	МассивВыделенныхСтрок = ТекущаяТаблицаФормы.ВыделенныеСтроки;

	Если МассивВыделенныхСтрок.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выделено ни одной строки таблицы для группового редактирования строк'"));
		Возврат;
	КонецЕсли;
	
	Если ТаблицаПутьКДанным = "" Тогда
		ТаблицаПутьКДанным = ТаблицаИмяЭлемента;
	КонецЕсли;
	
	КоллекцияДанныхФормы = ГрупповоеРедактированиеТабличныхЧастейКлиентСервер.ПолучитьКоллекциюДанныхФормыПоПутиКДанным(Форма, ТаблицаПутьКДанным);
	
	МассивДанныхТаблицы = Новый Массив;

	ДанныеТекущейСтроки = Новый Структура;
	ДанныеТекущейСтроки.Вставить("ПутьКДаннымТекущейТаблицы", ТаблицаПутьКДанным);

	// проверяем тип табличной части - ТаблицаЗначений
	// получаем Соответствие значений, где ключ Имя колонки, Значение - Массив значений по колонке
	
	ЭтоДопустимаяКоллекцияДанных = ГрупповоеРедактированиеТабличныхЧастейКлиентСервер.ЭтоДопустимаяКоллекцияДанныхФормы(КоллекцияДанныхФормы);         
	
	Если НЕ ЭтоДопустимаяКоллекцияДанных Тогда
		Возврат;                                         	
	КонецЕсли;                                              
		
	НомерТекущейСтрокиТаблицы	= ТекущаяТаблицаФормы.ТекущаяСтрока;
	Если ТипЗнч(ТекущаяТаблицаФормы.ТекущийЭлемент) = Тип("Полеформы") Тогда
		ИмяТекущейКолонкиТаблицы = ТекущаяТаблицаФормы.ТекущийЭлемент.Имя;
	Иначе
		ИмяТекущейКолонкиТаблицы = Неопределено;
	КонецЕсли; 
	
	// значения свойств должны быть определены в виде простых типов
	ИменаДопСвойств = ("МинимальноеЗначение, МаксимальноеЗначение, Маска, РежимПароля, Формат, ФорматРедактирования"); 
	
	Для каждого КлючИЗНачение Из ОписаниеКолонок Цикл
		
		//Проверим доступность колонок
		СтруктураКолонки = КлючИЗНачение.Значение;
		ЭлементКолонка = Форма.Элементы[СтруктураКолонки.ИмяЭлемента];
		Если ТипЗнч(ЭлементКолонка) <> Тип("ПолеФормы") Тогда
			Продолжить;
		КонецЕсли; 
		
		Если НЕ(ЭлементКолонка.Видимость И ЭлементКолонка.Доступность) ИЛИ ЭлементКолонка.ТолькоПросмотр Тогда
			Продолжить;
		КонецЕсли; 
		
		// Определим данные в текущей ячейке
		Если Нрег(КлючИЗНачение.Ключ) = НРег(ИмяТекущейКолонкиТаблицы) Тогда
			ДанныеТекущейСтроки.Вставить("ТекущаяВыделеннаяКолонка",	СтруктураКолонки.Имя);
			ДанныеТекущейСтроки.Вставить("ТекущаяВыделеннаяСтрока", 	НомерТекущейСтрокиТаблицы);
			ДанныеТекущейСтроки.Вставить("ЗначениеВТекущейЯчейке",		КоллекцияДанныхФормы.НайтиПоИдентификатору(НомерТекущейСтрокиТаблицы)[СтруктураКолонки.Имя]);
		КонецЕсли; 
		
		МассивЗначений = Новый Массив;
		Для Каждого ВыделеннаяСтрока Из МассивВыделенныхСтрок Цикл
			СтрокаТаблицы = КоллекцияДанныхФормы.НайтиПоИдентификатору(ВыделеннаяСтрока);

			СтруктураЗначений = Новый Структура;
			СтруктураЗначений.Вставить("ИндексВыделеннойСтроки",	ВыделеннаяСтрока);
			СтруктураЗначений.Вставить("Значение", 					СтрокаТаблицы[СтруктураКолонки.Имя]);
			МассивЗначений.Добавить(СтруктураЗначений);
		КонецЦикла;
		
		ДополнительныеСвойства = Новый Структура(ИменаДопСвойств);
		ЗаполнитьЗначенияСвойств(ДополнительныеСвойства, ЭлементКолонка);
		
		СтруктураКолонки.Вставить("Значения"				, МассивЗначений);    
        СтруктураКолонки.Вставить("ПараметрыВыбора"			, ПолучитьПараметрыВыбораДляПередачиНаСервер(Форма, ЭлементКолонка));
		СтруктураКолонки.Вставить("ДополнительныеСвойства"	, ДополнительныеСвойства);
		
		МассивДанныхТаблицы.Добавить(СтруктураКолонки);
	КонецЦикла; 		
		
	Если МассивДанныхТаблицы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет доступных колонок для группового редактирования строк'"));
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура("МассивДанныхТаблицы, ДанныеТекущейСтроки", МассивДанныхТаблицы, ДанныеТекущейСтроки);
	
	ТаблицаФормыДокумента = Форма.Элементы[ТаблицаИмяЭлемента];	
	ОткрытьФорму("Обработка.ГрупповоеРедактированиеТабличныхЧастейПТБ.Форма.Форма", ПараметрыФормы, ТаблицаФормыДокумента);

КонецПроцедуры

// Выполняет запись данных в таблицу формы из которой была вызвана групповая обработка строк.
//
// Параметры:
//	Форма	- УправляемаяФорма - произвольная форма справочника, документа, обработки, содержащая таблицы формы.
//ВНИМАНИЕ! Для формы обязательна инициализация реквизита "_Служебный_ОписаниеТаблицДляГрупповогоРедактирования_". 
//Подробнее в описании процедуры ГрупповоеРедактированиеТабличныхЧастейСервер.СформироватьОписаниеТаблицДляГрупповогоРедактирования()
//	ВыбранноеЗначение 	- Структура
//	СтандартнаяОбработка 	- Булево
//	ВызыватьОбработку		- Булево
//
Процедура ОбработкаОповещения(Форма, ПараметрыОповещения, знач ОповещениеПриРедактировании = Неопределено) Экспорт

	Если ТипЗнч(ПараметрыОповещения) <> Тип("Структура") Тогда 
		Возврат;
	КонецЕсли;
	
	ИмяСтруктуры = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОповещения, "ИмяСтруктуры", "");
	
	Если ИмяСтруктуры <> "ГрупповоеРедактированиеСтрокТаблицы" Тогда
		Возврат;
	КонецЕсли;

	КоллекцияДанныхФормы = ГрупповоеРедактированиеТабличныхЧастейКлиентСервер.ПолучитьКоллекциюДанныхФормыПоПутиКДанным(Форма, ПараметрыОповещения.ПутьКДаннымТекущейТаблицы); 
	
	ЭтоДопустимаяКоллекцияДанных = ГрупповоеРедактированиеТабличныхЧастейКлиентСервер.ЭтоДопустимаяКоллекцияДанныхФормы(КоллекцияДанныхФормы);         

	Если НЕ ЭтоДопустимаяКоллекцияДанных Тогда
		Возврат;
	КонецЕсли;                              
	
	ДанныеИзменены = Ложь;
	
	Для Каждого ЭлементМассива Из ПараметрыОповещения.МассивВыделенныхСтрок Цикл
	    СтрокаТаблицы = КоллекцияДанныхФормы.НайтиПоИдентификатору(ЭлементМассива);

		ЗначениеДо = СтрокаТаблицы[ПараметрыОповещения.Колонка];
		
		// Вызываем процедуру Формы "ПередИзменениемСтроки"
		Отказ = Ложь;
		
		Попытка
			Форма.Подключаемый_ГрупповоеРедактированиеПередИзменениемСтроки(СтрокаТаблицы, ПараметрыОповещения.Колонка, ЗначениеДо, ПараметрыОповещения.ЗначениеДляЗаполнения, Отказ);
		Исключение
			Продолжить;
		КонецПопытки;
		
		Если Отказ = Истина Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы[ПараметрыОповещения.Колонка] = ПараметрыОповещения.ЗначениеДляЗаполнения;
		
		СтруктураРезультат = Новый Структура("СтрокаТаблицы, Колонка, ЗначениеДляЗаполнения", СтрокаТаблицы, ПараметрыОповещения.Колонка, ПараметрыОповещения.ЗначениеДляЗаполнения);
		Если ОповещениеПриРедактировании <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПриРедактировании, СтруктураРезультат);
		КонецЕсли;  
		
		ДанныеИзменены = Истина;
	КонецЦикла;
	
	Если ДанныеИзменены Тогда
		Форма.Модифицированность = Истина;	
	КонецЕсли;
		
КонецПроцедуры

Процедура РасчетСуммыВыделенныхСтрок(Форма) Экспорт  

	ИмяРеквизитаОписаниеТаблицФормы = ГрупповоеРедактированиеТабличныхЧастейКлиентСервер.ИмяРеквизитаНастроекСуммирования();
	
	Элемент = Форма.ТекущийЭлемент;
	Если ТипЗнч(Элемент) <> Тип("ТаблицаФормы") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаХраненияСуммы = ГрупповоеРедактированиеТабличныхЧастейКлиентСервер.ИмяРеквизитаСуммыВыделенныхСтрок(Элемент.Имя);
   	
	Если НЕ ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, ИмяРеквизитаХраненияСуммы) Тогда
		Возврат;
	КонецЕсли;
	
	Форма[ИмяРеквизитаХраненияСуммы] = 0;

	Если НЕ ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, ИмяРеквизитаОписаниеТаблицФормы) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеТаблиц = Форма[ИмяРеквизитаОписаниеТаблицФормы];
	
	Если ТипЗнч(ОписаниеТаблиц) <> Тип("ФиксированноеСоответствие") Тогда
		Возврат;
	КонецЕсли; 
	
	ОписаниеТаблицы = ОписаниеТаблиц.Получить(Элемент.Имя);
	Если ТипЗнч(ОписаниеТаблицы) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяТекущейКолонки = Элемент.ТекущийЭлемент.Имя;
	
	ОписаниеКолонки = ОписаниеТаблицы.ОписаниеКолонок.Получить(ИмяТекущейКолонки);
	Если ОписаниеКолонки = Неопределено Тогда
		Возврат;	
	КонецЕсли; 

	Если НЕ ОписаниеКолонки.ТипЗначения.СодержитТип(Тип("Число")) Тогда
		Возврат;
	КонецЕсли; 
	
	ВыделенныеСтроки = Элемент.ВыделенныеСтроки;
	
	СуммаВыделенныхСтрок = 0;
	
	Для Каждого СтрокаСписка из ВыделенныеСтроки Цикл
		СуммаВыделенныхСтрок = СуммаВыделенныхСтрок + Элемент.ДанныеСтроки(СтрокаСписка)[ОписаниеКолонки.Имя];
	КонецЦикла;
	
	ЭлементОтображенияСуммы = Форма.Элементы[ИмяРеквизитаХраненияСуммы];
	
	РазрядностьПоФормату = ПолучитьТочностьПоФормату(Элемент.ТекущийЭлемент.Формат);
	
	Если РазрядностьПоФормату = Неопределено Тогда
		РазрядностьДробнойЧасти = ОписаниеКолонки.ТипЗначения.КвалификаторыЧисла.РазрядностьДробнойЧасти;
	Иначе
		РазрядностьДробнойЧасти = РазрядностьПоФормату;
	КонецЕсли;  
	
	ЭлементОтображенияСуммы.Формат = Элемент.ТекущийЭлемент.Формат;

	Форма[ИмяРеквизитаХраненияСуммы] = Окр(СуммаВыделенныхСтрок, РазрядностьДробнойЧасти);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТочностьПоФормату(знач СтрокаФормат)
    Если НЕ ЗначениеЗаполнено(СтрокаФормат) Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	ШаблонТочности = СтрНайти(СтрокаФормат, "ЧДЦ="); 
	
	Если ШаблонТочности = 0 Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	ПозицияТочностиНачало = ШаблонТочности + 4;
	ПозицияТочностиКонец = СтрНайти(СтрокаФормат, ";", , ПозицияТочностиНачало);
	
	ПозицияТочностиКонец = ?(ПозицияТочностиКонец = 0, СтрДлина(СтрокаФормат), ПозицияТочностиКонец);
	СтрокаТочность = Сред(СтрокаФормат, ПозицияТочностиНачало, ПозицияТочностиКонец);
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрокаТочность);	
КонецФункции

// Получает структуру данных для формирования параметров выбора
//
// Параметры:
//	Форма	- УправляемаяФорма - произвольная форма справочника, документа, обработки, содержащая таблицы формы.
//	ЭлементФормы = Элементформы(ПолеФормы)
//
Функция ПолучитьПараметрыВыбораДляПередачиНаСервер(Форма, ЭлементФормы) 
	                                    
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭлементФормы, "ПараметрыВыбора") = Ложь Тогда
		Возврат Неопределено;		
	КонецЕсли;
	
	ПараметрыВыбора = ЭлементФормы.ПараметрыВыбора;
	
	СоответствиеПараметровВыбора = Новый Соответствие;

	Если ТипЗнч(ПараметрыВыбора) = Тип("ФиксированныйМассив") Тогда
		Для Каждого ПараметрВыбора Из ПараметрыВыбора Цикл
			//Структура = Новый Структура("Имя, Значение");			
			//ЗаполнитьЗначенияСвойств(Структура, ПараметрВыбора);
			СоответствиеПараметровВыбора.Вставить(ПараметрВыбора.Имя, ПараметрВыбора.Значение);
		КонецЦикла; 
	КонецЕсли;               
   	
	ПараметрыВыбораИзСвязей = ПолучитьПараметрыВыбораИзСвязейПараметровВыбора(Форма, ЭлементФормы);
	
	Если ТипЗнч(ПараметрыВыбораИзСвязей) = Тип("ФиксированныйМассив") Тогда
		Для Каждого ПараметрВыбора Из ПараметрыВыбораИзСвязей Цикл 
			СтруктураОтбора = СоответствиеПараметровВыбора.Получить(ПараметрВыбора.Имя);
			Если СтруктураОтбора <> Неопределено Тогда
				Продолжить;				
			КонецЕсли;
			
			//Структура = Новый Структура("Имя, Значение");			
			//ЗаполнитьЗначенияСвойств(Структура, ПараметрВыбора);
			СоответствиеПараметровВыбора.Вставить(ПараметрВыбора.Имя, ПараметрВыбора.Значение);
		КонецЦикла; 
	КонецЕсли;               
	
	Возврат СоответствиеПараметровВыбора;	
		
КонецФункции

Функция ПолучитьПараметрыВыбораИзСвязейПараметровВыбора(Форма, ЭлементФормы) 
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЭлементФормы, "СвязиПараметровВыбора") = Ложь Тогда
		Возврат Неопределено;		
	КонецЕсли;
	
	СвязиПараметровВыбора = ЭлементФормы.СвязиПараметровВыбора;
	
	Если СвязиПараметровВыбора = Неопределено Тогда
		Возврат Неопределено;		
	КонецЕсли;                         
	
	Если ТипЗнч(СвязиПараметровВыбора) <> Тип("ФиксированныйМассив") Тогда
		Возврат Неопределено;		
	КонецЕсли;               
	
	Массив = Новый Массив;
	
	Для Каждого ЭлементСвязи Из СвязиПараметровВыбора Цикл      
		ЗначениеРеквизита = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ЭлементСвязи.ПутьКДанным);
		Структура = Новый Структура("Имя, Значение", ЭлементСвязи.Имя, ЗначениеРеквизита);			
		Массив.Добавить(Структура);
	КонецЦикла; 
	
	Возврат Новый ФиксированныйМассив(Массив);	
		
КонецФункции

#КонецОбласти
