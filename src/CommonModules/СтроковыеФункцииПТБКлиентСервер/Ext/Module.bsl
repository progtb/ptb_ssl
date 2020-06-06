﻿// См. подробнее:
//	- Преобразование utf-8
//		http://home.tiscali.nl/t876506/utf8tbl.html
//	- MIME
//		http://ru.wikipedia.org/wiki/MIME (см. RFC 2047)
//	- base64
//		http://ru.wikipedia.org/wiki/Base64 (см. MIME)
//	- про кодировку
//		http://ru.wikipedia.org/wiki/%D0%9D%D0%B0%D0%B1%D0%BE%D1%80_%D1%81%D0%B8%D0%BC%D0%B2%D0%BE%D0%BB%D0%BE%D0%B2
// Коэффициент Жаккара
//	- https://ru.wikipedia.org/wiki/%D0%9A%D0%BE%D1%8D%D1%84%D1%84%D0%B8%D1%86%D0%B8%D0%B5%D0%BD%D1%82_%D0%96%D0%B0%D0%BA%D0%BA%D0%B0%D1%80%D0%B0
//

#Область ПрограммныйИнтерфейс

// Выполняет сравнение двух предложений, путем расчета коэффициента Жаккара
// Рекомендуемое значение для сравнения - 0.25
//
// Параметры:
//	Предложение1	- Строка
//	Предложение2	- Строка
//	Параметры		- Структура
//		МинДлинаСлова	- Число - см. НормализацияСтроки
//		УдалитьПредлоги	- Булево - см. НормализацияСтроки
//		УдалитьСоюзы	- Булево - см. НормализацияСтроки
//		КолСимволов		- Число - см. ПолучитьЭквивалентныеСлова
//		МинКоэффициент	- Число	- см. ПолучитьЭквивалентныеСлова
//
// Возвращаемое значение:
//   Число
// 
Функция КоэффициентНечеткогоСравненияПредложений(знач Предложение1, знач Предложение2, знач Параметры = Неопределено) Экспорт 
	Если ПустаяСтрока(Предложение1) Тогда
		Возврат 1;
	КонецЕсли;
	Если ПустаяСтрока(Предложение2) Тогда 
		Возврат 1;
	КонецЕсли;
	
	ПроверитьПараметрыСравнения(Параметры);
	
	ЗначПредложение1 = НормализацияСтроки(Предложение1, Параметры.МинДлинаСлова, Параметры.УдалитьПредлоги, Параметры.УдалитьСоюзы);
	ЗначПредложение2 = НормализацияСтроки(Предложение2, Параметры.МинДлинаСлова, Параметры.УдалитьПредлоги, Параметры.УдалитьСоюзы);
	
	Подстроки1 = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЗначПредложение1, " ", Истина, Истина);
	Подстроки2 = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЗначПредложение2, " ", Истина, Истина);
	
	Эквиваленты = ПолучитьЭквивалентныеСлова(Подстроки1, Подстроки2, Параметры.КолСимволов, Параметры.МинКоэффициент);
	
	КолСлов1		= Подстроки1.Количество();
	КолСлов2		= Подстроки2.Количество();
	КолЭквивалентов	= Эквиваленты.Количество();
	
	Возврат (1 * КолЭквивалентов) / (КолСлов1 + КолСлов2 - КолЭквивалентов); 
КонецФункции

// Возвращает массив из совпадающих слов между двумя массивами с исп. метода ПроверитьЭквивалентностьСлов
// Рекомендуется нормализовать предложения или слова в массивах
//
// Параметры:
//	ПервыйМассив	- Массив
//	ВторойМассив	- Массив
//	КолСимволов		- Число - см. ПроверитьЭквивалентностьСлов
//	Минимум			- Число - см. ПроверитьЭквивалентностьСлов
//
// Возвращаемое значение:
//	Массив
//
Функция ПолучитьЭквивалентныеСлова(знач ПервыйМассив, знач ВторойМассив, знач КолСимволов = 2, знач Минимум = 0.45) Экспорт
	МассивЭквивалентов	= Новый Массив;
	ИспользованныеСлова	= Новый Массив(ВторойМассив.Количество());
	
	Для Индекс1 = 0 По ПервыйМассив.ВГраница() Цикл
		Для Индекс2 = 0 По ВторойМассив.ВГраница() Цикл
			Если ИспользованныеСлова[Индекс2] = Истина Тогда
				Продолжить;
			КонецЕсли;
			
			Подстрока1 = ПервыйМассив[Индекс1];
			Подстрока2 = ВторойМассив[Индекс2];
			
			Если ПроверитьЭквивалентностьСлов(Подстрока1, Подстрока2, КолСимволов, Минимум) Тогда
				МассивЭквивалентов.Добавить(Подстрока1);
				ИспользованныеСлова[Индекс2] = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивЭквивалентов;
КонецФункции

// Выполняет сравнение двух слов, путем расчета коэффициента Жаккара и возвращает признак сопоставимости
//
// Параметры:
//	ПервоеСлово - Строка
//	ВтороеСлово - Строка
//	КолСимволов - Число - длина строки при вычислении коэффициента
//	Минимум		- Число - минимальное значение коэффициента
//
// Возвращаемое значение:
//	Булево
//
Функция ПроверитьЭквивалентностьСлов(знач ПервоеСлово, знач ВтороеСлово, знач КолСимволов = 2, знач Минимум = 0.45) Экспорт 
	КоэффициентТанимото = ПолучитьКоэффициентЭквивалентностиСлов(ПервоеСлово, ВтороеСлово, КолСимволов);
	Возврат Минимум <= КоэффициентТанимото;
КонецФункции

// Выполняет сравнение двух слов, путем расчета коэффициента Жаккара
//
// Параметры:
//	ПервоеСлово - Строка
//	ВтороеСлово - Строка
//	КолСимволов - Число - длина строки при вычислении коэффициента
//
// Возвращаемое значение:
//	Булево
//
Функция ПолучитьКоэффициентЭквивалентностиСлов(знач ПервоеСлово, знач ВтороеСлово, знач КолСимволов = 2) Экспорт 
	КоличествоПодстрок1 = СтрДлина(ПервоеСлово) - КолСимволов + 1;
	КоличествоПодстрок2 = СтрДлина(ВтороеСлово) - КолСимволов + 1;
	
	Если КоличествоПодстрок1 <= 0 ИЛИ КоличествоПодстрок2 <= 0 Тогда
		Возврат ?(ПервоеСлово = ВтороеСлово, 1, 0);
	КонецЕсли;
	
	Если ПервоеСлово = ВтороеСлово Тогда
		Возврат 1;
	КонецЕсли;
	
	КоличествоСовпадений	= 0;
	ИспользованныеСимволы	= Новый Массив(СтрДлина(ВтороеСлово) - КолСимволов + 1);
	Для Индекс1 = 1 По КоличествоПодстрок1 Цикл
		ЗначПодстрока1 = Сред(ПервоеСлово, Индекс1, КолСимволов);
		Для Индекс2 = 1 По КоличествоПодстрок2 Цикл
			Если ИспользованныеСимволы[Индекс2-1] = Истина Тогда
				Продолжить;
			КонецЕсли;
			
			ЗначПодстрока2 = Сред(ВтороеСлово, Индекс2, КолСимволов);
			Если ЗначПодстрока1 = ЗначПодстрока2 Тогда
				КоличествоСовпадений = КоличествоСовпадений + 1;
				ИспользованныеСимволы[Индекс2-1] = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат (1 * КоличествоСовпадений) / (КоличествоПодстрок1 + КоличествоПодстрок2 - КоличествоСовпадений);
КонецФункции

// Выполняет нормализацию строки для дальнейшего сравнения
//	- перевод в нижний регистр
//	- удаление всех символов кроме латиницы, кириллицы, чисел и пробелов
//	- удаление предлогов и/или союзов по требованию
//	- удаление слов с длиной меньше указанной, кроме содержащих числа
//
// Параметры:
//	СтрЗначение 	- Строка
//	МинДлина		- Число - минимальная длина допустимого слова, остальные удаляются
//	УдалитьПредлоги	- Булево - удаляются предлоги
//	УдалитьСоюзы	- Булево - удаляются союзы
//	Локализация		- Строка - ru, en, (см. СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПолучитьПредлоги/ПолучитьСоюзы)
//
// Возвращаемое значение:
//   Строка
// 
Функция НормализацияСтроки(знач СтрЗначение, знач МинДлина = 4, знач УдалитьПредлоги = Истина, знач УдалитьСоюзы = Истина, знач Локализация = "ru") Экспорт 
	Перем КэшСимволов;
	
	НРегСтрока		= НРег(СтрЗначение);
	ДлинаНРегСтрока	= СтрДлина(НРегСтрока);
	Если ДлинаНРегСтрока = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	ЕстьКириллица	= Ложь;
	ЗнакиПрепинания	= СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПолучитьМассивЗнаковПрепинания(Истина);
	
	СтрРезультат	= "";
	
	МассивОценки = Новый Массив(ДлинаНРегСтрока);
	Для Индекс = 1 По ДлинаНРегСтрока Цикл
		ТекИндекс	= Индекс-1;
		ПредИндекс	= ?(Индекс = 1, Неопределено, ТекИндекс-1);
		СледИндекс	= ?(Индекс = ДлинаНРегСтрока, Неопределено, ТекИндекс+1);
		
		ЗначСимвол = Сред(НРегСтрока, Индекс, 1);
		СледСимвол = ?(СледИндекс = Неопределено, "", Сред(НРегСтрока, Индекс+1, 1));
		
		// текущий символ может быть оценен ранее
		Если ТипЗнч(МассивОценки[ТекИндекс]) = Тип("Структура") Тогда
			ЗначимостьСимвола = МассивОценки[ТекИндекс];
		Иначе
			ЗначимостьСимвола = ПроверитьЗначимостьСимвола(ЗначСимвол, КэшСимволов);
			МассивОценки[ТекИндекс] = ЗначимостьСимвола;
		КонецЕсли;
		
		// оценим следующий символ, пред и текущий уже оценены
		Если СледИндекс <> Неопределено Тогда
			МассивОценки[СледИндекс] = ПроверитьЗначимостьСимвола(СледСимвол, КэшСимволов);
		КонецЕсли;
		
		// проверим "-", ".", ","
		Если ЗначСимвол = "-" Тогда
			Если ПредИндекс <> Неопределено И СледИндекс <> Неопределено
				И МассивОценки[ПредИндекс].ЭтоЗначимый И МассивОценки[СледИндекс].ЭтоЗначимый
				И НЕ МассивОценки[ПредИндекс].ЭтоПробел И НЕ МассивОценки[СледИндекс].ЭтоПробел Тогда
				
				СтрРезультат = СтрРезультат + "-";
				Продолжить;
				
			КонецЕсли;
		ИначеЕсли СтрНайти(".,xх", ЗначСимвол) > 0 Тогда
			Если ПредИндекс <> Неопределено И СледИндекс <> Неопределено
				И МассивОценки[ПредИндекс].ЭтоЧисло И МассивОценки[СледИндекс].ЭтоЧисло Тогда
				
				СтрРезультат = СтрРезультат + ".";
				Продолжить;
				
			КонецЕсли;
		ИначеЕсли ЗначСимвол = "/" Тогда
			ЗаменитьНаПробел = (ПредИндекс = Неопределено
				ИЛИ СледИндекс = Неопределено
				ИЛИ МассивОценки[ПредИндекс].ЭтоПробел
				ИЛИ МассивОценки[СледИндекс].ЭтоПробел);
				
			СтрРезультат = СтрРезультат + ?(ЗаменитьНаПробел, " ", "/");
			
			Продолжить;
		КонецЕсли;
		
		// кириллица, латиница, число, пробел
		Если НЕ ЗначимостьСимвола.ЭтоЗначимый Тогда
			СтрРезультат = СтрРезультат + " ";
			Продолжить;
		КонецЕсли;
		
		ЕстьКириллица = ?(ЕстьКириллица, Истина, ЗначимостьСимвола.ЭтоКириллица);
		
		СтрРезультат = СтрРезультат + ?(ЗначимостьСимвола.ЭтоПробел, " ", ЗначСимвол);
	КонецЦикла;
	
	Если ЕстьКириллица Тогда
		СтрРезультат = СтрЗаменить(СтрРезультат, "ё", "е");
	КонецЕсли;
	
	МассивУдалить	= Новый Массив;
	МассивПредлоги	= Новый Массив;
	МассивСоюзы		= Новый Массив;
	Если УдалитьПредлоги Тогда
		МассивПредлоги = СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПолучитьПредлоги(Локализация);
		//ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивУдалить, МассивПредлоги, Истина);
	КонецЕсли;
	Если УдалитьСоюзы Тогда
		МассивСоюзы = СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПолучитьСоюзы(Локализация);
		//ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивУдалить, МассивСоюзы, Истина);
	КонецЕсли;
	
	МассивПодстрок	= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрРезультат, " ", Истина, Истина);
	МассивРезультат	= Новый Массив;
	Для Каждого Подстрока Из МассивПодстрок Цикл
		Если СтрДлина(Подстрока) >= МинДлина Тогда
			МассивРезультат.Добавить(Подстрока);
			Продолжить;
		КонецЕсли;
		
		СтрокаПроверки = СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими("0123456789", Подстрока, "__________");
		Если СтрНайти(СтрокаПроверки, "_") > 0 Тогда
			МассивРезультат.Добавить(Подстрока);
		ИначеЕсли МассивУдалить.Найти(Подстрока) = Неопределено Тогда
			МассивРезультат.Добавить(Подстрока);
		ИначеЕсли МассивПредлоги.Найти(Подстрока) = Неопределено Тогда
			МассивРезультат.Добавить(Подстрока);
		ИначеЕсли МассивСоюзы.Найти(Подстрока) = Неопределено Тогда
			МассивРезультат.Добавить(Подстрока);
		КонецЕсли;
	КонецЦикла;
	
	СтрРезультат = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(МассивРезультат, " ", Истина);
	
	Возврат СтрРезультат;
КонецФункции

// Возвращает начало строки по указанному количеству слов
//
// Параметры:
//	СтрокаПоиска	- Строка - строка из которой надо получить начало
//	КоличествоСлов	- Число - количество строк из начала
//
// Возвращаемое значение:
//   Строка
// 
Функция ПолучитьНачальнуюСтрокуДляПоиска(знач СтрокаПоиска, знач КоличествоСлов = 3, знач УдалятьЗнакиПрепинания = Ложь) Экспорт
	МассивИтого	= Новый Массив;
	
	МассивСлов	= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаПоиска, " ", Истина, Истина);
	ИтогоСлов	= МассивСлов.Количество();
	Для Индекс = 0 По Мин(ИтогоСлов, КоличествоСлов) - 1 Цикл
		ТекСтрока = МассивСлов[Индекс];
		
		// удалим знаки препинания
		Если УдалятьЗнакиПрепинания Тогда
			ТекСтрока = УдалитьЗнакиПрепинанияСКонца(ТекСтрока);
		КонецЕсли;
		
		МассивИтого.Добавить(ТекСтрока);
	КонецЦикла;
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(МассивИтого, " ", Истина);
	
	//Счетчик		= 1;
	//НачПозиция	= 1;
	//СледПозиция = СтрНайти(СтрокаПоиска, " ",, НачПозиция);
	//КолСимволов	= СтрДлина(СтрокаПоиска);
	//Пока Счетчик <= КоличествоСлов И СледПозиция <> 0 Цикл
	//	// определим значимую часть поиска
	//	ТекСтрока	= Сред(СтрокаПоиска, НачПозиция, СледПозиция - НачПозиция);
	//	
	//	// удалим знаки препинания
	//	Если УдалятьЗнакиПрепинания Тогда
	//		ТекСтрока = УдалитьЗнакиПрепинанияСКонца(ТекСтрока);
	//	КонецЕсли;
	//	
	//	// добавим в строку поиска только значимую часть
	//	НачПоиска = НачПоиска + ?(ПустаяСтрока(НачПоиска), "", " ") + ТекСтрока;
	//	Если СледПозиция + 1 >= КолСимволов Тогда
	//		Прервать;
	//	КонецЕсли;
	//	
	//	// определим необходимость проверки след. слова
	//	НачПозиция	= СледПозиция + 1;
	//	СледПозиция = СтрНайти(СтрокаПоиска, " ",, СледПозиция + 1);
	//	Счетчик		= Счетчик + ?(ПустаяСтрока(ТекСтрока), 0, 1);
	//	
	//	Если СледПозиция = 0 И Счетчик = КоличествоСлов Тогда
	//		СледПозиция = СтрДлина(СтрокаПоиска) + 1;
	//	КонецЕсли;		
	//КонецЦикла;
	//
	//Возврат НачПоиска;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Удаляет все знаки препинания справа
//
// Параметры:
//	СтрЗначение 		- Строка
//	УчитыватьДопЗнаки	- Булево - дополнительно удаляются выделительные знаки
//		см. СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПолучитьМассивЗнаковПрепинания
//
// Возвращаемое значение:
//   Строка
// 
Функция УдалитьЗнакиПрепинанияСКонца(знач СтрЗначение, знач УчитыватьДопЗнаки = Ложь) Экспорт
	СтрЗначение = СокрЛП(СтрЗначение);
	
	КонтрольныйМассив	= СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПолучитьМассивЗнаковПрепинания(УчитыватьДопЗнаки);
	СтрЗначениеПред		= СтрЗначение + ".";
	Пока СтрЗначениеПред <> СтрЗначение Цикл
		СтрЗначениеПред = СтрЗначение;
		
		Для Каждого ЗнакПрепинания Из КонтрольныйМассив Цикл
			КонтрольнаяДлина 	= СтрДлина(ЗнакПрепинания);
			КонтрольныеСимволы	= Прав(СтрЗначение, КонтрольнаяДлина);
			Если КонтрольныеСимволы = ЗнакПрепинания Тогда
				СтрЗначение = Лев(СтрЗначение, СтрДлина(СтрЗначение) - КонтрольнаяДлина);
			КонецЕсли;
		КонецЦикла;		
	КонецЦикла;
	
	Возврат СтрЗначение;
КонецФункции

Функция ПроверитьЗначимостьСимвола(знач ЗначСимвол, КэшСимволов = Неопределено) Экспорт
	Возврат СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПроверитьЗначимостьСимвола(ЗначСимвол);
КонецФункции

#КонецОбласти 

#Область КодировкаДекодированиеСтрок

// Перевод строкового значения в base64
Функция СтрокаВBase64(знач Значение) Экспорт
	
	Алфавит		= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	Результат	= "";
	КолСимволов	= СтрДлина(Значение);
	
	МассивПодстрок	= Новый Массив;
	КолБлоков		= Цел(КолСимволов / 3);
	ОстатокСтроки	= Значение;
	Для НомерБлока = 1 По КолБлоков Цикл
		МассивПодстрок.Добавить(Лев(ОстатокСтроки, 3));
		ОстатокСтроки = Сред(ОстатокСтроки, 4);
	КонецЦикла;
	Если НЕ ПустаяСтрока(ОстатокСтроки) Тогда
		МассивПодстрок.Добавить(ОстатокСтроки);
	КонецЕсли;
	
	Для Каждого Подстрока_3 Из МассивПодстрок Цикл
		Подстрока_4 = "";
		
		// Получение числа из 3 символов
		СуммаПодстроки = 0;
		Разряд = 2;
		Пока Разряд >= 0 Цикл
			Множитель = 1;
			Для ИндексРазряда = 1 По Разряд Цикл
				Множитель = Множитель * 256;
			КонецЦикла;
			
			ЗначениеКода	= КодСимвола(Подстрока_3, 3 - Разряд);
			СуммаПодстроки	= СуммаПодстроки + ?(ЗначениеКода > 0, ЗначениеКода * Множитель, 0);
			Разряд			= Разряд - 1;
		КонецЦикла;
		
		// Получение 4 символов из числа
		Разряд = 3;
		Пока Разряд >= 0 Цикл
			Делитель = 1;
			Для ИндексРазряда = 1 По Разряд Цикл
				Делитель = Делитель * 64;
			КонецЦикла;
			
			ЗначениеКода = Цел(СуммаПодстроки / Делитель);
			Если СтрДлина(Подстрока_3) < 3 И ЗначениеКода = 0 Тогда
				ЗначениеКода = 64;
			КонецЕсли;
			
			Подстрока_4		= Подстрока_4 + Сред(Алфавит, ЗначениеКода + 1, 1);
			СуммаПодстроки	= СуммаПодстроки % Делитель;
			Разряд			= Разряд - 1;
		КонецЦикла;
		
		Результат = Результат + Подстрока_4;
	КонецЦикла;
	
	Возврат Результат;
		
КонецФункции

// Перевод значения base64 в строку
Функция Base64ВСтроку(знач Значение) Экспорт
	
	Алфавит		= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	Результат	= "";
	КолСимволов	= СтрДлина(Значение);
	
	МассивПодстрок	= Новый Массив;
	КолБлоков		= Цел(КолСимволов / 4);
	ОстатокСтроки	= Значение;
	Для НомерБлока = 1 По КолБлоков Цикл
		МассивПодстрок.Добавить(Лев(ОстатокСтроки, 4));
		ОстатокСтроки = Сред(ОстатокСтроки, 5);
	КонецЦикла;
	Если НЕ ПустаяСтрока(ОстатокСтроки) Тогда
		МассивПодстрок.Добавить(ОстатокСтроки);
	КонецЕсли;
	
	Для Каждого Подстрока_4 Из МассивПодстрок Цикл
		Подстрока_3 = "";
		
		// Получение числа из 4 символов
		СуммаПодстроки = 0;
		Разряд = 3;
		Пока Разряд >= 0 Цикл
			Множитель = 1;
			Для ИндексРазряда = 1 По Разряд Цикл
				Множитель = Множитель * 64;
			КонецЦикла;
			
			Символ = Сред(Подстрока_4, 4 - Разряд, 1);
			Если Символ = "=" Тогда
				ЗначениеКода = 0;
			Иначе 
				ЗначениеКода = Найти(Алфавит, Символ) - 1;
			КонецЕсли;
			
			СуммаПодстроки	= СуммаПодстроки + ЗначениеКода * Множитель;
			Разряд			= Разряд - 1;
		КонецЦикла;
		
		// Получение 3 символов из числа
		Разряд = 2;
		Пока Разряд >= 0 Цикл
			Делитель = 1;
			Для ИндексРазряда = 1 По Разряд Цикл
				Делитель = Делитель * 256;
			КонецЦикла;
			
			ЗначениеКода = Цел(СуммаПодстроки / Делитель);
			Если ЗначениеКода <> 0 Тогда
				Подстрока_3 = Подстрока_3 + Символ(ЗначениеКода);
			КонецЕсли;
			
			СуммаПодстроки	= СуммаПодстроки % Делитель;
			Разряд			= Разряд - 1;
		КонецЦикла;
		
		Результат = Результат + Подстрока_3;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Перевод строки unicode в UTF-8
Функция СтрокаВUTF_8(знач Значение) Экспорт
	
	КолСимволов = СтрДлина(Значение);
	Результат	= "";
	
	Для Индекс = 1 По КолСимволов Цикл
		ЗначениеКода = КодСимвола(Значение, Индекс);
		
		Массив = Новый Массив;
		
		Если ЗначениеКода < 128 Тогда
			Массив.Добавить(ЗначениеКода);
		ИначеЕсли ЗначениеКода >= 128 И ЗначениеКода <= 2047 Тогда
			Массив.Добавить(192 + Цел(ЗначениеКода / 64));
			Массив.Добавить(128 + ЗначениеКода % 64);
		ИначеЕсли ЗначениеКода >= 2048 И ЗначениеКода <= 65535 Тогда
			Массив.Добавить(224 + Цел(ЗначениеКода / 64 / 64));
			Массив.Добавить(128 + Цел(ЗначениеКода / 64) % 64);
			Массив.Добавить(128 + ЗначениеКода % 64);
		ИначеЕсли ЗначениеКода >= 65536 И ЗначениеКода <= 2097151 Тогда
			Массив.Добавить(240 + Цел(ЗначениеКода / 64 / 64 / 64));
			Массив.Добавить(128 + Цел(ЗначениеКода / 64 / 64) % 64);
			Массив.Добавить(128 + Цел(ЗначениеКода / 64) % 64);
			Массив.Добавить(128 + ЗначениеКода % 64);
		ИначеЕсли ЗначениеКода >= 2097152 И ЗначениеКода <= 67108863 Тогда
			Массив.Добавить(248 + Цел(ЗначениеКода / 64 / 64 / 64 / 64));
			Массив.Добавить(128 + Цел(ЗначениеКода / 64 / 64 / 64) % 64);
			Массив.Добавить(128 + Цел(ЗначениеКода / 64 / 64) % 64);
			Массив.Добавить(128 + Цел(ЗначениеКода / 64) % 64);
			Массив.Добавить(128 + ЗначениеКода % 64);
		ИначеЕсли ЗначениеКода >= 67108864 И ЗначениеКода <= 2147483647 Тогда
			Массив.Добавить(252 + Цел(ЗначениеКода / 64 / 64 / 64 / 64 / 64));
			Массив.Добавить(128 + Цел(ЗначениеКода / 64 / 64 / 64 / 64) % 64);
			Массив.Добавить(128 + Цел(ЗначениеКода / 64 / 64 / 64) % 64);
			Массив.Добавить(128 + Цел(ЗначениеКода / 64 / 64) % 64);
			Массив.Добавить(128 + Цел(ЗначениеКода / 64) % 64);
			Массив.Добавить(128 + ЗначениеКода % 64);
		КонецЕсли;
		
		Для Каждого ЗначениеКода Из Массив Цикл
			Результат = Результат + Символ(ЗначениеКода);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Перевод строки UTF-8 в unicode
Функция UTF_8ВСтроку(знач Значение) Экспорт
	
	КолСимволов = СтрДлина(Значение);
	Результат	= "";
	
	Для Индекс = 1 По КолСимволов Цикл
		а = КодСимвола(Значение, Индекс);
		б = КодСимвола(Значение, Индекс + 1);
		в = КодСимвола(Значение, Индекс + 2);
		г = КодСимвола(Значение, Индекс + 3);
		д = КодСимвола(Значение, Индекс + 4);
		е = КодСимвола(Значение, Индекс + 5);
		
		Если а >= 0 И а <= 127 Тогда
			ЗначениеКода = а;
		ИначеЕсли а >= 192 И а <= 223 Тогда
			Индекс			= Индекс + 1;
			ЗначениеКода	= (а - 192) * 64
							+ (б - 128);
		ИначеЕсли а >= 224 И а <= 239 Тогда
			Индекс			= Индекс + 2;
			ЗначениеКода	= (а - 224) * 64 * 64
							+ (б - 128) * 64
							+ (в - 128);
		ИначеЕсли а >= 240 И а <= 247 Тогда
			Индекс			= Индекс + 3;
			ЗначениеКода	= (а - 240) * 64 * 64 * 64
							+ (б - 128) * 64 * 64
							+ (в - 128) * 64
							+ (г - 128);
		ИначеЕсли а >= 248 И а <= 251 Тогда
			Индекс			= Индекс + 4;
			ЗначениеКода	= (а - 248) * 64 * 64 * 64 * 64
							+ (б - 128) * 64 * 64 * 64
							+ (в - 128) * 64 * 64
							+ (г - 128) * 64
							+ (д - 128);
		ИначеЕсли а >= 252 И а <= 253 Тогда
			Индекс			= Индекс + 5;
			ЗначениеКода	= (а - 252) * 64 * 64 * 64 * 64 * 64
							+ (б - 128) * 64 * 64 * 64 * 64
							+ (в - 128) * 64 * 64 * 64
							+ (г - 128) * 64 * 64
							+ (д - 128) * 64
							+ (е - 128);
		КонецЕсли;
		
		Результат = Результат + Символ(ЗначениеКода);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Перевод строки из формата MIME
Функция MIMEВСтроку(знач Значение) Экспорт
	Результат = "";
	
	Если ЭтоЗначениеMIME(Значение) Тогда
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Значение, "?");
		
		Кодировка	= МассивПодстрок[1];
		Метод		= МассивПодстрок[2];
		Значение	= МассивПодстрок[3];
		
		Если Метод = "B" Тогда
			Значение = Base64ВСтроку(Значение);
		КонецЕсли;
		
		Результат = ДекодироватьСтроку(Значение, Кодировка);
		
	КонецЕсли;
	
	Возврат ?(ПустаяСтрока(Результат), Значение, Результат);
КонецФункции

// Перевод строки в формат MIME
Функция СтрокаВMIME(знач Значение, знач Кодировка = "utf-8", знач Метод = "Q") Экспорт
	
	НРегКодировка	= НРег(Кодировка);
	Значение		= ЗакодироватьСтроку(Значение, Кодировка);
	
	Возврат "=?" + НРегКодировка + "?" + Метод + "?" + ?(Метод = "B", СтрокаВBase64(Значение), Значение) + "?=";
	
КонецФункции

// Изменение кодировки строки по указанному значению в unicode
Функция ДекодироватьСтроку(знач Значение, знач Кодировка) Экспорт
	
	НРегКодировка	= НРег(Кодировка);
	Результат		= "";
	
	Если НРегКодировка = "utf-8" Тогда
		Результат = UTF_8ВСтроку(Значение);
	Иначе 
		Соответствие = СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПолучитьМассивСимволов(Кодировка);
		Если НЕ ТипЗнч(Соответствие) = Тип("Соответствие") Тогда
			Возврат Значение;
		КонецЕсли;
		
		Длина = СтрДлина(Значение);
		Для Индекс = 1 По Длина Цикл
			Код = КодСимвола(Значение, Индекс);
			
			Символ = Соответствие.Получить(Код);
			Если Символ = Неопределено Тогда
				Результат = Результат + Сред(Значение, Индекс, 1);
			Иначе 
				Результат = Результат + Символ;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Изменение кодировки строки из unicode в указанное значение
Функция ЗакодироватьСтроку(знач Значение, знач Кодировка) Экспорт
	
	НРегКодировка	= НРег(Кодировка);
	Результат		= "";
	
	Если НРегКодировка = "utf-8" Тогда
		Результат = СтрокаВUTF_8(Значение);
	Иначе 
		Соответствие = СтроковыеФункцииПТБСлужебныйКлиентСерверПовтИсп.ПолучитьМассивКодов(Кодировка);
		Если НЕ ТипЗнч(Соответствие) = Тип("Соответствие") Тогда
			Возврат Значение;
		КонецЕсли;
		
		Длина = СтрДлина(Значение);
		Для Индекс = 1 По Длина Цикл
			Символ = Сред(Значение, Индекс, 1);
			
			Код = Соответствие.Получить(Символ);
			Если Код = Неопределено Тогда
				Результат = Результат + Сред(Значение, Индекс, 1);
			Иначе 
				Результат = Результат + Символ(Код);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Разбор заголовка письма с выделением From, To, Subject
Функция РазборатьЗаголовокПисьма(знач Значение) Экспорт
	
	
	
КонецФункции

#КонецОбласти 

#Область Склонения

////////////////////////////////////////////////////////////////////////////////
// СКЛОНЕНИЯ (c) Jurer Production http://superjur.narod.ru

// Функция для склонения одного слова
// z1 - само слово
// z2 - номер падежа
// z3 - пол
// z4 - 1-склонять как фамилию, 2-имя, 3-отчество
Функция ПадежС(z1,Знач z2=2,Знач z3="*",z4=0) Экспорт
  z5=Найти(z1,"-");
  z6=?(z5=0,"","-"+ПадежС(Сред(z1,z5+1,СтрДлина(z1)-z5+1),z2,z3,z4));
  z1=НРег(?(z5=0,z1,Лев(z1,z5-1)));
  z7=Прав(z1,3);z8=Прав(z7,2);z9=Прав(z8,1);
  z5=СтрДлина(z1);
  za=Найти("ая ия ел ок яц ий па да ца ша ба та га ка",z8);
  zb=Найти("аеёийоуэюяжнгхкчшщ",Лев(z7,1));
  zc=Макс(z2,-z2);
  zd=?(za=4,5,Найти("айяь",z9));
  zd=?((zc=1)или(z9=".")или((z4=2)и(Найти("оиеу"+?(z3="ч","","бвгджзклмнпрстфхцчшщъ"),z9)>0))или((z4=1)и(Найти("мия мяэ лия кия жая лея",z7)>0)),9,?((zd=4)и(z3="ч"),2,?(z4=1,?(Найти("оеиую",z9)+Найти("их ых аа еа ёа иа оа уа ыа эа юа яа",z8)>0,9,?(z3<>"ч",?(za=1,7,?(z9="а",?(za>18,1,6),9)),?(((Найти("ой ый",z8)>0)и(z5>4)и(Прав(z1,4)<>"опой"))или((zb>10)и(za=16)),8,zd))),zd)));
  ze=Найти("лец вей бей дец пец мец нец рец вец аец иец ыец бер",z7);
  zf=?((zd=8)и(zc<>5),?((zb>15)или(Найти("жий ний",z7)>0),"е","о"),?(z1="лев","ьв",?((Найти("аеёийоуэюя",Сред(z1,z5-3 ,1))=0)и((zb>11)или(zb=0))и(ze<>45),"",?(za=7,"л",?(za=10,"к",?(za=13,"йц",?(ze=0,"",?(ze<12,"ь"+?(ze=1,"ц",""),?(ze<37,"ц",?(ze<49,"йц","р"))))))))));
//  zf=?((zd=9)или((z4=3)и(z3="ы")),z1,Лев(z1,z5-?((zd>6)или(zf<>""),2,?(zd>0,1,0)))+zf+СокрП(Сред("а у а "+Сред("оыые",Найти("внч",z9)+1,1)+"ме "+?(Найти("гжкхш",Лев(z8,1))>0,"и","ы")+" е у ойе я ю я ем"+?(za=16,"и","е")+" и е ю ейе и и ь ьюи и и ю ейи ойойу ойойойойуюойойгомуго"+?((zf="е")или(za=16)или((zb>12)и(zb<16)),"и","ы")+"мм",10*zd+2*zc-3,2)));
  zf=?((zd=9)или((z4=3)и(Прав(z1,1)="ы")),z1,Лев(z1,z5-?((zd>6)или(zf<>""),2,?(zd>0,1,0)))+zf+СокрП(Сред("а у а "+Сред("оыые",Найти("внч",z9)+1,1)+"ме "+?(Найти("гжкхш",Лев(z8,1))>0,"и","ы")+" е у ойе я ю я ем"+?(za=16,"и","е")+" и е ю ейе и и ь ьюи и и ю ейи ойойу ойойойойуюойойгомуго"+?((zf="е")или(za=16)или((zb>12)и(zb<16)),"и","ы")+"мм",10*zd+2*zc-3,2)));
Возврат ?(""=z1,"",?(z4>0,ВРег(Лев(zf,1))+?((z2<0)и(z4>1),".",Сред(zf,2)),zf)+z6);
КонецФункции

// z1 - фамилия имя отчество например Железняков Юрий Юрьевич
// z2 - Падеж ( по  умолчанию = 2 - родительный)
// 2 - родительный  ( нет кого?    ) Железнякова Юрия Юрьевича     
// 3 - дательный    ( кому?        ) Железнякову Юрию Юрьевичу 
// 4 - винительный  ( вижу кого?   ) Железнякова Юрия Юрьевича  
// 5 - творительный ( кем?         ) Железняковым Юрием Юрьевичем    
// 6 - предложный   ( о ком?       ) Железнякове Юрии Юрьевиче 
// Если задать Z2 меньше 0, то на выходе получим от -1=Железняков Ю. Ю. до -6=Железнякове Ю. Ю.
// z3 - параметр Пол может не указываться, но при наличии фамилий с 
// инициалами точное определение пола невозможно, поэтому предлагается задавать пол этим
// параметром  1 - мужской 2 - женский  
// ДЛЯ СКЛОНЕНИЯ ПРОФЕССИЙ ИСПОЛЬЗУЙТЕ ФУНКЦИЮ ПАДЕЖП И БУДЕТ ВАМ СЧАСТЬЕ!
// ---------------------------------------------------------------------------------------
// Бибик Галушка Цой Николайчик Наталия Петровна Герценберг Кривошей Капица-Метелица
// Если Падеж(Фио ,1 ,3),       то на выходе получим Фамилия Имя Отчество и т.д.
// Если Падеж(Фио ,1 ,3,"1" ),  то                   Фамилия 
// Если Падеж(Фио ,1 ,3,"2" ),  то                   Имя 
// Если Падеж(Фио ,1 ,3,"3" ),  то                   Отчество 
// Если Падеж(Фио, 1 ,3,"12" ), то                   Фамилия Имя 
// Если Падеж(Фио, 1 ,3,"23" ), то                   Имя Отчество 
// Если Падеж(Фио,-1 ,3,"231" ),то                   И. О. Фамилия 
// Если Падеж(Фио,-1 ,3,"23" ), то                   И. О.  
// 10-11-2003 3-20
Функция Падеж(z1,z2=2,z3=3,z4="123",z5=1) Экспорт
	z6=Нрег(Прав(СокрП(z1),4));
	z7=Прав(z6,1);
  Возврат?(z5<4,Падеж(СокрЛП(СтрЗаменить(Сред(z1,Найти(z1+" "," ")+1),".",". ")),z2,z3,СтрЗаменить(z4,z5,ПадежС(?((z5=3)и(z7="ы"),z1,Лев(z1,Найти(z1+" "," ")-1)),z2,Сред("ча"+z7,?(z3=3,?(z6="оглы",1,?(z6="кызы",1,3)),z3),1),z5)+" "),z5+1),z4);
КонецФункции

Функция ПадежП(Знач z1,Знач z2,z3=0) Экспорт
  z1=СокрЛП(z1);z4=Найти(z1+" "," ")+1;z5=Лев(z1,z4-2);z6=Прав(z5,2);
  z7=?((Найти("ая ий ый",z6)>0)и(Найти("ющий нный",Сред(z1,z4-5,4))=0)и(z3=0),"1","*");
Возврат НРег(?((z6="ая")или(Прав(z6,1)="а"),ПадежС(z5,z2,z7,1)+" "+ПадежС(Сред(z1,z4),z2),ПадежС(z5,z2,"ч",1)+?((z6="ий")и(Найти(z1," ")=0),""," "+?(z7="1",ПадежП(Сред(z1,z4),z2,Число(z7)),Сред(z1,z4)))));
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьПараметрыСравнения(Параметры)
	
	Если НЕ ТипЗнч(Параметры) = Тип("Структура") Тогда
		Параметры = Новый Структура;
	КонецЕсли; 
	Если НЕ Параметры.Свойство("МинДлинаСлова") Тогда
		Параметры.Вставить("МинДлинаСлова", 4);
	КонецЕсли;
	Если НЕ Параметры.Свойство("УдалитьПредлоги") Тогда
		Параметры.Вставить("УдалитьПредлоги", Истина);
	КонецЕсли;
	Если НЕ Параметры.Свойство("УдалитьСоюзы") Тогда
		Параметры.Вставить("УдалитьСоюзы", Истина);
	КонецЕсли;
	Если НЕ Параметры.Свойство("КолСимволов") Тогда
		Параметры.Вставить("КолСимволов", 2);
	КонецЕсли;
	Если НЕ Параметры.Свойство("МинКоэффициент") Тогда
		Параметры.Вставить("МинКоэффициент", 0.45);
	КонецЕсли;
КонецФункции

Функция ЭтоЗначениеMIME(знач Значение)
	Значение	= СокрЛП(Значение);
	Лев2		= Лев(Значение, 2);
	Прав2		= Прав(Значение, 2);
	
	Возврат (Лев2 = "=?" И Прав2 = "?=");
КонецФункции

#КонецОбласти
 
