// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/yard/
// ----------------------------------------------------------

#Использовать v8runner

Перем МенеджерОбработкиДанных;  // ВнешняяОбработкаОбъект - обработка-менеджер, вызвавшая данный обработчик
Перем Идентификатор;            // Строка                 - идентификатор обработчика, заданный обработкой-менеджером
Перем ПараметрыОбработки;       // Структура              - параметры обработки
Перем Лог;                      // Объект                 - объект записи лога приложения

Перем ПутьККонфигурации;        // Строка                 - путь к файлу конфигурации (CF) предыдущей версии
Перем ПутьКОбновлению;          // Строка                 - путь к файлу обновления (CFU) новой версии
Перем База_СтрокаСоединения;    // Строка                 - строка соединения служебной базы 1С
                                //                          для выполнения обновления

Перем НакопленныеДанные;        // Массив(Структура)      - результаты обработки данных

#Область ПрограммныйИнтерфейс

// Функция - признак возможности обработки, принимать входящие данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может принимать входящие данные для обработки;
//	         Ложь - обработка не принимает входящие данные;
//
Функция ПринимаетДанные() Экспорт
	
	Возврат Ложь;
	
КонецФункции // ПринимаетДанные()

// Функция - признак возможности обработки, возвращать обработанные данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может возвращать обработанные данные;
//	         Ложь - обработка не возвращает данные;
//
Функция ВозвращаетДанные() Экспорт
	
	Возврат Истина;
	
КонецФункции // ВозвращаетДанные()

// Функция - возвращает список параметров обработки
// 
// Возвращаемое значение:
//	Структура                                - структура входящих параметров обработки
//      *Тип                    - Строка         - тип параметра
//      *Обязательный           - Булево         - Истина - параметр обязателен
//      *ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//      *Описание               - Строка         - описание параметра
//
Функция ОписаниеПараметров() Экспорт
	
	Параметры = Новый Структура();
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ПутьККонфигурации",
	                          "Строка",
	                          Истина,
	                          "",
	                          "путь к файлу конфигурации (CF) предыдущей версии");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПутьКОбновлению",
	                          "Строка",
	                          Истина,
	                          "",
	                          "путь к файлу обновления (CFU) новой версии");

	ДобавитьОписаниеПараметра(Параметры,
	                          "База_СтрокаСоединения",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "строка соединения служебной базы 1С для выполнения обновления");

	Возврат Параметры;
	
КонецФункции // ОписаниеПараметров()

// Функция - Возвращает обработку - менеджер
// 
// Возвращаемое значение:
//	ВнешняяОбработкаОбъект - обработка-менеджер
//
Функция МенеджерОбработкиДанных() Экспорт
	
	Возврат МенеджерОбработкиДанных;
	
КонецФункции // МенеджерОбработкиДанных()

// Процедура - Устанавливает обработку - менеджер
//
// Параметры:
//	НовыйМенеджерОбработкиДанных      - ВнешняяОбработкаОбъект - обработка-менеджер
//
Процедура УстановитьМенеджерОбработкиДанных(Знач НовыйМенеджерОбработкиДанных) Экспорт
	
	МенеджерОбработкиДанных = НовыйМенеджерОбработкиДанных;
	
КонецПроцедуры // УстановитьМенеджерОбработкиДанных()

// Функция - Возвращает идентификатор обработчика
// 
// Возвращаемое значение:
//	Строка - идентификатор обработчика
//
Функция Идентификатор() Экспорт
	
	Возврат Идентификатор;
	
КонецФункции // Идентификатор()

// Процедура - Устанавливает идентификатор обработчика
//
// Параметры:
//	НовыйИдентификатор      - Строка - новый идентификатор обработчика
//
Процедура УстановитьИдентификатор(Знач НовыйИдентификатор) Экспорт
	
	Идентификатор = НовыйИдентификатор;
	
КонецПроцедуры // УстановитьИдентификатор()

// Функция - Возвращает значения параметров обработки
// 
// Возвращаемое значение:
//	Структура - параметры обработки
//
Функция ПараметрыОбработкиДанных() Экспорт
	
	Возврат ПараметрыОбработки;
	
КонецФункции // ПараметрыОбработкиДанных()

// Процедура - Устанавливает значения параметров обработки данных
//
// Параметры:
//	НовыеПараметры      - Структура     - значения параметров обработки
//
Процедура УстановитьПараметрыОбработкиДанных(Знач НовыеПараметры) Экспорт
	
	ПараметрыОбработки = НовыеПараметры;
	
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПутьККонфигурации"    , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПутьКОбновлению"      , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("База_СтрокаСоединения", ПараметрыОбработки);

КонецПроцедуры // УстановитьПараметрыОбработкиДанных()

// Функция - Возвращает значение параметра обработки данных
// 
// Параметры:
//	ИмяПараметра      - Строка           - имя получаемого параметра
//
// Возвращаемое значение:
//	Произвольный      - значение параметра
//
Функция ПараметрОбработкиДанных(Знач ИмяПараметра) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ПараметрыОбработки.Свойство(ИмяПараметра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыОбработки[ИмяПараметра];
	
КонецФункции // ПараметрОбработкиДанных()

// Процедура - Устанавливает значение параметра обработки
//
// Параметры:
//	ИмяПараметра      - Строка           - имя устанавливаемого параметра
//	Значение          - Произвольный     - новое значение параметра
//
Процедура УстановитьПараметрОбработкиДанных(Знач ИмяПараметра, Знач Значение) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		ПараметрыОбработки = Новый Структура();
	КонецЕсли;
	
	ПараметрыОбработки.Вставить(ИмяПараметра, Значение);

	Если НЕ ЕстьПеременнаяМодуля(ИмяПараметра) Тогда
		Возврат;
	КонецЕсли;

	Если ВРег(ИмяПараметра) = ВРег("ПутьККонфигурации") Тогда
		ВремФайл = Новый Файл(Значение);
		ПутьККонфигурации = ВремФайл.ПолноеИмя;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("ПутьКОбновлению") Тогда
		ВремФайл = Новый Файл(Значение);
		ПутьКОбновлению = ВремФайл.ПолноеИмя;
	Иначе
		Выполнить(СтрШаблон("%1 = Значение;", ИмяПараметра));
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрОбработкиДанных()

// Процедура - устанавливает данные для обработки
//
// Параметры:
//	Данные      - Структура     - значения параметров обработки
//
Процедура УстановитьДанные(Знач ВходящиеДанные) Экспорт
	
КонецПроцедуры // УстановитьДанные()

// Процедура - выполняет обработку данных
//
Процедура ОбработатьДанные() Экспорт

	Конфигуратор = Новый УправлениеКонфигуратором();

	Конфигуратор.УстановитьКонтекст(База_СтрокаСоединения, "", "");

	Лог.Информация("[%1]: Загрузка конфигурации из файла %2 в базу %3.",
	               СокрЛП(ЭтотОбъект),
	               ПутьККонфигурации,
	               База_СтрокаСоединения);

	Конфигуратор.ЗагрузитьКонфигурациюИзФайла(ПутьККонфигурации);

	Лог.Информация("[%1]: Обновление конфигурации из файла %2.",
	               СокрЛП(ЭтотОбъект),
	               ПутьКОбновлению);

	Конфигуратор.ОбновитьКонфигурациюИзФайла(ПутьКОбновлению);

	ФайлОбновления = Новый Файл(ПутьКОбновлению);
	
	ПутьКНовойКонфигурации = ОбъединитьПути(ФайлОбновления.Путь, "1cv8.cf");

	Лог.Информация("[%1]: Выгрузка обновленной конфигурации в файл %2.",
	               СокрЛП(ЭтотОбъект),
	               ПутьКНовойКонфигурации);

	Конфигуратор.ВыгрузитьКонфигурациюВФайл(ПутьКНовойКонфигурации);

	ПродолжениеОбработкиДанныхВызовМенеджера(ПутьКНовойКонфигурации);

	ЗавершениеОбработкиДанныхВызовМенеджера();

КонецПроцедуры // ОбработатьДанные()

Функция РезультатОбработки() Экспорт
	
	Возврат НакопленныеДанные;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	Лог.Информация("[%1]: Завершение обработки данных.", ТипЗнч(ЭтотОбъект));

	ЗавершениеОбработкиДанныхВызовМенеджера();
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныйПрограммныйИнтерфейс

// Функция - возвращает объект управления логированием
//
// Возвращаемое значение:
//  Объект      - объект управления логированием
//
Функция Лог() Экспорт
	
	Возврат Лог;

КонецФункции // Лог()

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("cf cf-path", "", "путь к файлу конфигурации (CF) предыдущей версии")
	       .ТСтрока()
	       .ВОкружении("YARD_CF_PATH");

	Команда.Опция("cfu cfu-path", "", "путь к файлу обновления (CFU) новой версии")
	       .ТСтрока()
	       .ВОкружении("YARD_CFU_PATH");

	Команда.Опция("C ibconnection", "", "строка подключения к служебной базе 1С для выполнения обновления")
	       .ТСтрока()
	       .ВОкружении("YARD_IB_CONNECTION");

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ВыводОтладочнойИнформации = Команда.ЗначениеОпции("verbose");

	ПараметрыПриложения.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	УстановитьПараметрОбработкиДанных("ПутьККонфигурации"    , Команда.ЗначениеОпции("cf-path"));
	УстановитьПараметрОбработкиДанных("ПутьКОбновлению"      , Команда.ЗначениеОпции("cfu-path"));
	УстановитьПараметрОбработкиДанных("База_СтрокаСоединения", Команда.ЗначениеОпции("ibconnection"));

	ОбработатьДанные();

КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

// Процедура - выполняет действия обработки элемента данных
// и оповещает обработку-менеджер о продолжении обработки элемента
//
//	Параметры:
//		Элемент    - Произвольный     - Элемент данных для продолжения обработки
//
Процедура ПродолжениеОбработкиДанныхВызовМенеджера(Элемент)
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ПродолжениеОбработкиДанных(Элемент, Идентификатор);
	
КонецПроцедуры // ПродолжениеОбработкиДанныхВызовМенеджера()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанныхВызовМенеджера()
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ЗавершениеОбработкиДанных(Идентификатор);
	
КонецПроцедуры // ЗавершениеОбработкиДанныхВызовМенеджера()

#КонецОбласти // СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

#Область СлужебныеПроцедурыИФункции

// Процедура - добавляет описание параметра обработки
// 
// Параметры:
//     ОписаниеПараметров     - Структура      - структура описаний параметров
//     Параметр               - Строка         - имя параметра
//     Тип                    - Строка         - список возможных типов параметра
//     Обязательный           - Булево         - Истина - параметр обязателен
//     ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//     Описание               - Строка         - описание параметра
//
Процедура ДобавитьОписаниеПараметра(ОписаниеПараметров
	                              , Параметр
	                              , Тип
	                              , Обязательный = Ложь
	                              , ЗначениеПоУмолчанию = Неопределено
	                              , Описание = "")
	
	Если НЕ ТипЗнч(ОписаниеПараметров) = Тип("Структура") Тогда
		ОписаниеПараметров = Новый Структура();
	КонецЕсли;
	
	ОписаниеПараметра = Новый Структура();
	ОписаниеПараметра.Вставить("Тип"                , Тип);
	ОписаниеПараметра.Вставить("Обязательный"       , Обязательный);
	ОписаниеПараметра.Вставить("ЗначениеПоУмолчанию", ЗначениеПоУмолчанию);
	ОписаниеПараметра.Вставить("Описание"           , Описание);
	
	ОписаниеПараметров.Вставить(Параметр, ОписаниеПараметра);
	
КонецПроцедуры // ДобавитьОписаниеПараметра()

// Процедура - устанавливает значение переменной модуля с указанным именем
// из значения структуры с тем же именем или значение по умолчанию
// 
// Параметры:
//	ИмяПараметра          - Строка           - имя параметра для установки значения
//	СтруктураПараметров   - Структура        - структуры значений параметров
//	ЗначениеПоУмолчанию   - Произвольный     - значение переменной по умолчанию
//
// Возвращаемое значение:
//	Булево      - Истина - переменная существует; Ложь - в противном случае.
//
Процедура УстановитьПараметрОбработкиДанныхИзСтруктуры(Знач ИмяПараметра,
	                                                  Знач СтруктураПараметров,
	                                                  Знач ЗначениеПоУмолчанию = "")

	Если НЕ ЕстьПеременнаяМодуля(ИмяПараметра) Тогда
		Возврат;
	КонецЕсли;

	ЗначениеПараметра = ЗначениеПоУмолчанию;

	Если СтруктураПараметров.Свойство(ИмяПараметра) Тогда
		ЗначениеПараметра = СтруктураПараметров[ИмяПараметра];
	КонецЕсли;

	Выполнить(СтрШаблон("%1 = ЗначениеПараметра;", ИмяПараметра));

КонецПроцедуры // УстановитьПараметрОбработкиДанныхИзСтруктуры()

// Функция - проверяет наличие в текущем модуле переменной с указанным именем
// 
// Параметры:
//	ИмяПеременной      - Строка           - имя переменной для проверки
//
// Возвращаемое значение:
//	Булево      - Истина - переменная существует; Ложь - в противном случае.
//
Функция ЕстьПеременнаяМодуля(Знач ИмяПеременной)

	Попытка
		ЗначениеПеременной = Вычислить(ИмяПеременной);
	Исключение
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;

КонецФункции // ЕстьПеременнаяМодуля()

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//  Менеджер	 - МенеджерОбработкиДанных    - менеджер обработки данных - владелец
// 
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта(Менеджер = Неопределено)

	УстановитьМенеджерОбработкиДанных(Менеджер);

	Лог = ПараметрыПриложения.Лог();

	Лог.Информация("[%1]: Инициализирован обработчик", ТипЗнч(ЭтотОбъект));

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
