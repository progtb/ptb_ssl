﻿// Copyright (c) 2023, ООО ПрогТехБизнес
// Лицензия Attribution 4.0 International (CC BY 4.0)

// Возвращает массив знаков препинания
//
// Параметры:
//	УчитыватьДопЗнаки	- Булево - дополнительно удаляются выделительные знаки
//		К выделительными знаками препинания являются запятая (две запятые);
//		тире (два тире); двоеточие и тире, употребляемые вместе.
//
// Возвращаемое значение:
//   ТипВид - описание возвращаемого значения
// 
Функция ПолучитьМассивЗнаковПрепинания(знач УчитыватьДопЗнаки = Ложь) Экспорт 
	ЗнакиПрепинания = ". ? ! ... , ; : -";
	
	Если УчитыватьДопЗнаки Тогда
		ЗнакиПрепинания = ЗнакиПрепинания + " ,, -- :-";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЗнакиПрепинания, " ", Истина, Истина);
КонецФункции

Функция ПолучитьПредлоги(знач Локализация = "ru") Экспорт 
	Если Локализация = "ru" Тогда
		Подстрока = "в, без, до, из, к, на, по, о, от, при, с, у, и, нет, за, над, для, об, под, про, между, среди, перед, около, вдоль, через, сквозь";
	ИначеЕсли Локализация = "en" Тогда
		Подстрока = "оn, in, at, near, over, under, between, among, behind, асrоss, through";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Подстрока, ",", Истина, Истина);
КонецФункции

Функция ПолучитьСоюзы(знач Локализация = "ru") Экспорт 
	Если Локализация = "ru" Тогда
		Подстрока = "а, но, да, или, что, как, так, если, хотя";
	ИначеЕсли Локализация = "en" Тогда
		Подстрока = "";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Подстрока, ",", Истина, Истина);
КонецФункции

Функция ПроверитьЗначимостьСимвола(знач ЗначСимвол) Экспорт
	Если НЕ ТипЗнч(ЗначСимвол) = Тип("Строка") Тогда
		ЗначСимвол = "";
	КонецЕсли;
	
	СтруктураЗначимость = Новый Структура("ЭтоПробел, ЭтоКириллица, ЭтоЛатиница, ЭтоЧисло, ЭтоЗначимый, ЭтоСпецСимвол",
		Ложь, Ложь, Ложь, Ложь, Ложь, Ложь);
	
	Если СтрДлина(ЗначСимвол) = 0 Тогда
		Возврат СтруктураЗначимость;
	КонецЕсли;
	
	СтруктураЗначимость.ЭтоСпецСимвол = (ЗначСимвол = Символы.ВК
		ИЛИ ЗначСимвол = Символы.ВТаб
		ИЛИ ЗначСимвол = Символы.ПС
		ИЛИ ЗначСимвол = Символы.ПФ
		ИЛИ ЗначСимвол = Символы.Таб);
		
	Если НЕ СтруктураЗначимость.ЭтоСпецСимвол Тогда
		СтруктураЗначимость.ЭтоПробел = (СтрНайти(" " + Символы.НПП, ЗначСимвол) > 0);
		Если НЕ СтруктураЗначимость.ЭтоПробел Тогда
			СтруктураЗначимость.ЭтоКириллица = СтроковыеФункцииКлиентСерверРФ.ТолькоКириллицаВСтроке(ЗначСимвол);
			Если НЕ СтруктураЗначимость.ЭтоКириллица Тогда
				СтруктураЗначимость.ЭтоЛатиница = СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(ЗначСимвол);
				Если НЕ СтруктураЗначимость.ЭтоЛатиница Тогда
					СтруктураЗначимость.ЭтоЧисло = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЗначСимвол);
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СтруктураЗначимость.ЭтоЗначимый = (СтруктураЗначимость.ЭтоПробел
		ИЛИ СтруктураЗначимость.ЭтоКириллица
		ИЛИ СтруктураЗначимость.ЭтоЛатиница
		ИЛИ СтруктураЗначимость.ЭтоЧисло);
	
	Возврат СтруктураЗначимость;
КонецФункции

