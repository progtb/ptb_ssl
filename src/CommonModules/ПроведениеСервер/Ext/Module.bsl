﻿
#Область ПрограммныйИнтерфейс

// Проверка ручной корректировки по документу и удаление движений.
// допустимо использование свойств аналогично процедуре УдалитьДвиженияРегистратора
//
// Параметры:
//	ДокументОбъект - ДокументОбъект - объект документа для удаления записей из движений
//
// Возвращаемое значение:
//	Булево.
//		Истина - движения изменены вручную
//
Функция РучнаяКорректировкаОбработкаПроведения(ДокументОбъект, Отказ)  Экспорт
	
	Если ДокументОбъект.Метаданные().Реквизиты.Найти("РучнаяКорректировка") <> Неопределено Тогда
		РучнаяКорректировка = ДокументОбъект.РучнаяКорректировка;
	Иначе 
		РучнаяКорректировка = Ложь;
	КонецЕсли;
	
	Если РучнаяКорректировка Тогда
		ИзменитьАктивностьПоРегистратору(ДокументОбъект, Отказ);
		ТекстСообщения = НСтр("ru='Движения документа отредактированы вручную и не могут быть автоматически актуализированы.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Истина;
	Иначе
		УдалитьДвиженияРегистратора(ДокументОбъект, Отказ);
		Возврат Ложь;
	КонецЕсли;
 	
КонецФункции // РучнаяКорректировкаОбработкаПроведения()

// Процедура удаления существующих движений документа при перепроведении (отмене проведения).
// Удаление записей можно производить выборочно, для этого параметр объекта ДополнительныеСвойства
// необходимо добавить следующие свойства:
//	ВыборочноОчищатьРегистры - Булево - Истина если необходимо очищать конкретные регистры
//	СписокРегистровДляОчистки - Массив - список имен регистров для очистки
//		Например: РегистрСведенийНаборЗаписей.ДополнительныеСведения
//
// Параметры:
//	ДокументОбъект - ДокументОбъект - объект документа для удаления записей из движений
//
Процедура УдалитьДвиженияРегистратора(ДокументОбъект, Отказ) Экспорт
	
	ВыборочноОчищатьРегистры = (ДокументОбъект.ДополнительныеСвойства.Свойство("ВыборочноОчищатьРегистры")
		И ДокументОбъект.ДополнительныеСвойства.ВыборочноОчищатьРегистры);
	
	СписокРегистровДляОчисткиДвижений = ?(ДокументОбъект.ДополнительныеСвойства.Свойство("СписокРегистровДляОчистки"),
		ДокументОбъект.ДополнительныеСвойства.СписокРегистровДляОчистки, Новый Массив);
	
	//Очистка движений документа
	Для Каждого Движение Из ДокументОбъект.Движения Цикл
		
		Если ВыборочноОчищатьРегистры И (СписокРегистровДляОчисткиДвижений.Найти(ТипЗнч(Движение))<>неопределено) Тогда
			Продолжить;
		КонецЕсли;
		Движение.Очистить();
		
	КонецЦикла;
	
	//Запись пустых наборов движений в ИБ(очистка старых движений)	
	Для Каждого Движение ИЗ ДокументОбъект.Движения Цикл
		
		Если (ВыборочноОчищатьРегистры И (СписокРегистровДляОчисткиДвижений.Найти(ТипЗнч(Движение))<>неопределено))
			ИЛИ НЕ ВыборочноОчищатьРегистры Тогда
			
			Если Движение.Количество() > 0 Тогда
				ПозицияТочки = Найти(Строка(Движение), ".");
				ТипРегистра = Лев(Строка(Движение), ПозицияТочки - 13);
				ИмяРегистра = СокрП(Сред(Строка(Движение), ПозицияТочки + 1));
				
				ЕСли ТипРегистра = "РегистрНакопления" Тогда
					МетаданныеНабора = Метаданные.РегистрыНакопления[ИмяРегистра];
					Набор = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
					
				ИначеЕсли ТипРегистра = "РегистрБухгалтерии" Тогда
					МетаданныеНабора = Метаданные.РегистрыБухгалтерии[ИмяРегистра];
					Набор = РегистрыБухгалтерии[ИмяРегистра].СоздатьНаборЗаписей();
					
				ИначеЕсли ТипРегистра = "РегистрСведений" Тогда
					МетаданныеНабора = Метаданные.РегистрыСведений[ИмяРегистра];
					Набор = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
					
				ИначеЕсли ТипРегистра = "РегистрРасчета" Тогда
					МетаданныеНабора = Метаданные.РегистрыРасчета[ИмяРегистра];
					Набор = РегистрыРасчета[ИмяРегистра].СоздатьНаборЗаписей();
					
				КонецЕсли;
				
				Если НЕ ПравоДоступа("Изменение", МетаданныеНабора) Тогда
					// отсутствуют права на всю таблицу регистра
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Нарушение прав доступа к регистру %1.'"),
						МетаданныеНабора.Представление());
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
					Возврат;
				КонецЕсли;
				
				Набор.Отбор.Регистратор.Установить(ДокументОбъект.Ссылка);			
				
			Иначе
				Набор = Движение;
			КонецЕсли;
			
			Попытка
				Набор.Записать();
			Исключение
				// возможно «сработал» RLS или механизм даты запрета изменения
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Ошибка при удалении движений:
					|%1'"),
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ВызватьИсключение НСтр("ru='Операция не выполнена'");
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Процедура включения активности движений при проведении документа, движения которого
// заданы вручную
Процедура ИзменитьАктивностьПоРегистратору(ДокументОбъект, Отказ, ВключитьАктивность = Истина) Экспорт
	
	Для Каждого Набор ИЗ ДокументОбъект.Движения Цикл
		
		Набор.Прочитать();
		Набор.УстановитьАктивность(ВключитьАктивность);
		
		Попытка
			Набор.Записать();
		Исключение
			// возможно «сработал» RLS или механизм даты запрета изменения
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка при изменении активности движений:
				|%1'"),
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение НСтр("ru='Операция не выполнена'");
		КонецПопытки;	
		
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти
