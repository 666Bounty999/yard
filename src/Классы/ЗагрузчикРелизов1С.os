// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/yard/
// ----------------------------------------------------------

Перем МенеджерОбработкиДанных;  // ВнешняяОбработкаОбъект - обработка-менеджер, вызвавшая данный обработчик
Перем Идентификатор;            // Строка                 - идентификатор обработчика, заданный обработкой-менеджером
Перем ПараметрыОбработки;       // Структура              - параметры обработки
Перем Лог;                      // Объект                 - объект записи лога приложения

Перем Данные;                   // Массив(Структура)      - список конфигураций для обработки

Перем ЗагруженныеВерсии;        // Соответствие           - список найденных версий в каталоге загрузки

Перем ИмяПользователя;          // Строка                 - имя пользователя сайта релизов 1С
Перем ПарольПользователя;       // Строка                 - пароль пользователя сайта релизов 1С

Перем ФильтрПриложений;         // Массив(Строка)         - фильтр имен приложений
Перем ФильтрВерсий;             // Массив(Строка)         - фильтр номеров версий
Перем ФильтрВерсийНачинаяСДаты; // Дата                   - фильтр по начальной дате версии (включая)
Перем ФильтрВерсийДоДаты;       // Дата                   - фильтр по последней дате версии (включая)
Перем ФильтрДистрибутива;       // Строка                 - фильтр заголовков ссылок на скачивание дистрибутива
                                //                          если не указан, то будет выполнена проверка наличия ссылки
                                //                          "Полный дистрибутив", затем "Дистрибутив обновления"

Перем КаталогДляСохранения;     // Строка                 - каталог для загрузки релизов 1С
Перем ЗагружатьСуществующие;    // Булево                 - Истина - будут загружены все найденные релизы
                                //                          независимо от существующих в каталоге для загрузки
                                //                          Ложь - будут загружены только отсутствующие
                                //                          в каталоге для загрузки релизы
                                //                          (проверяются файлы description.json)
Перем ОграничениеКоличества;    // Число                  - ограничение количества загружаемых за 1 раз версий
Перем РаспаковыватьEFD;         // Булево                 - Истина - если загруженный архив содержит упакованный шаблон
                                //                          конфигурации (содержит файл 1cv8.efd),
                                //                          то он будет распакован
Перем КаталогДляРаспаковкиEFD;  // Строка                 - каталог для распаковки шаблона конфигурации
Перем ФайлыДляРаспаковкиEFD;    // Массив(Строка)         - список файлов для распаковки из архива EFD дистрибутива
                                //                          конфигурации, если не указан, то распаковываются все файлы
Перем УдалитьПослеРаспаковкиEFD;// Булево                 - Истина - после рапаковки загруженный архив будет удален
Перем ПолучатьБетаВерсии;       // Булево                 - Истина - будут получены ознакомительные версии


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
	                          "ИмяПользователя",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Имя пользователя сайта релизов 1С");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ПарольПользователя",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Пароль пользователя сайта релизов 1С");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрПриложений",
	                          "Массив",
	                          Ложь,
	                          "",
	                          "Фильтр имен приложений");
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрВерсий",
	                          "Массив",
	                          Ложь,
	                          "",
	                          "Фильтр номеров версий");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрВерсийНачинаяСДаты",
	                          "Дата",
	                          Ложь,
	                          "",
	                          "Фильтр по начальной дате версии (включая)");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрВерсийДоДаты",
	                          "Дата",
	                          Ложь,
	                          "",
	                          "Фильтр по последней дате версии (включая)");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ФильтрДистрибутива",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "Фильтр заголовков ссылок на скачивание дистрибутива
	                          |если не указан, то будет выполнена проверка наличия ссылки
	                          |""Полный дистрибутив"", затем ""Дистрибутив обновления""");

	ДобавитьОписаниеПараметра(Параметры,
	                          "КаталогДляСохранения",
	                          "Строка",
	                          Истина,
	                          "",
	                          "каталог для загрузки релизов 1С");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ЗагружатьСуществующие",
	                          "Булево",
	                          Ложь,
	                          Ложь,
	                          "Истина - будут загружены все найденные релизы
	                          |независимо от существующих в каталоге для загрузки
	                          |Ложь - будут загружены только отсутствующие
	                          |в каталоге для загрузки релизы
	                          |(проверяются файлы description.json)");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ОграничениеКоличества",
	                          "Число",
	                          Ложь,
	                          0,
	                          "ограничение количества загружаемых за 1 раз версий");

	ДобавитьОписаниеПараметра(Параметры,
	                          "РаспаковыватьEFD",
	                          "Булево",
	                          Ложь,
	                          "",
	                          "Истина - если загруженный архив содержит упакованный шаблон
	                          |конфигурации (содержит файл 1cv8.efd), то он будет распакован");

	ДобавитьОписаниеПараметра(Параметры,
	                          "КаталогДляРаспаковкиEFD",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "каталог для распаковки шаблона конфигурации");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ФайлыДляРаспаковкиEFD",
	                          "Массив",
	                          Ложь,
	                          "",
	                          "список файлов для распаковки из архива EFD дистрибутива конфигурации,
	                          |если не указан, то распаковываются все файлы");

	ДобавитьОписаниеПараметра(Параметры,
	                          "УдалитьПослеРаспаковкиEFD",
	                          "Булево",
	                          Ложь,
	                          "",
	                          "Истина - после рапаковки загруженный архив будет удален");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПолучатьБетаВерсии",
	                          "Булево",
	                          Ложь,
	                          Истина,
	                          "Если установлен будут получены ознакомительные версии
	                          |в противном случае будут получены только релизные версии");

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
	
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяПользователя"          , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПарольПользователя"       , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ФильтрВерсийНачинаяСДаты" , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ФильтрВерсийДоДаты"       , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПолучатьБетаВерсии"       , ПараметрыОбработки, Ложь);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ФильтрДистрибутива"       , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("КаталогДляСохранения"     , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ЗагружатьСуществующие"    , ПараметрыОбработки, Ложь);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ОграничениеКоличества"    , ПараметрыОбработки, 0);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("РаспаковыватьEFD"         , ПараметрыОбработки, Ложь);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("КаталогДляРаспаковкиEFD"  , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ФайлыДляРаспаковкиEFD"    , ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("УдалитьПослеРаспаковкиEFD", ПараметрыОбработки, Ложь);

	ФильтрПриложений = Новый Массив();
	Если ПараметрыОбработки.Свойство("ФильтрПриложений") Тогда
		Если ТипЗнч(ПараметрыОбработки.ФильтрПриложений) = Тип("Массив") Тогда
			ФильтрПриложений = ПараметрыОбработки.ФильтрПриложений;
		Иначе
			ФильтрПриложений = СтрРазделить(ПараметрыОбработки.ФильтрПриложений, "|");
		КонецЕсли;
	КонецЕсли;

	ФильтрВерсий = Новый Массив();
	Если ПараметрыОбработки.Свойство("ФильтрВерсий") Тогда
		Если ТипЗнч(ПараметрыОбработки.ФильтрВерсий) = Тип("Массив") Тогда
			ФильтрВерсий = ПараметрыОбработки.ФильтрВерсий;
		Иначе
			ФильтрВерсий = СтрРазделить(ПараметрыОбработки.ФильтрВерсий, "|");
		КонецЕсли;
	КонецЕсли;

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

	Если ВРег(ИмяПараметра) = "ФИЛЬТРПРИЛОЖЕНИЙ" Тогда
		Если ТипЗнч(Значение) = Тип("Массив") Тогда
			ФильтрПриложений = Значение;
		Иначе
			ФильтрПриложений = СтрРазделить(Значение, "|");
		КонецЕсли;
	ИначеЕсли ВРег(ИмяПараметра) = "ФИЛЬТРВЕРСИЙ" Тогда
		Если ТипЗнч(Значение) = Тип("Массив") Тогда
			ФильтрВерсий = Значение;
		Иначе
			ФильтрВерсий = СтрРазделить(Значение, "|");
		КонецЕсли;
	ИначеЕсли ВРег(ИмяПараметра) = "КАТАЛОГДЛЯСОХРАНЕНИЯ" Тогда
		ВремФайл = Новый Файл(Значение);
		КаталогДляСохранения = ВремФайл.ПолноеИмя;
	ИначеЕсли ВРег(ИмяПараметра) = "КАТАЛОГДЛЯРАСПАКОВКИEFD" Тогда
		ВремФайл = Новый Файл(Значение);
		КаталогДляРаспаковкиEFD = ВремФайл.ПолноеИмя;
	Иначе
		Выполнить(СтрШаблон("%1 = Значение;", ИмяПараметра));
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрОбработкиДанных()

// Процедура - устанавливает данные для обработки
//
// Параметры:
//	ВходящиеДанные      - Структура     - значения параметров обработки
//
Процедура УстановитьДанные(Знач ВходящиеДанные) Экспорт
	
	Данные = Новый Массив();
	
	Если ТипЗнч(ВходящиеДанные) = Тип("Массив") Тогда
		Данные = ВходящиеДанные;
	Иначе
		Данные.Добавить(ВходящиеДанные);
	КонецЕсли;
	
КонецПроцедуры // УстановитьДанные()

// Процедура - выполняет обработку данных
//
// Параметры:
//	Обозреватель      - ОбозревательСайта1С     - объект для получения данных с сайта 1С
//
Процедура ОбработатьДанные(Обозреватель = Неопределено) Экспорт
	
	Если Обозреватель = Неопределено Тогда
		Обозреватель = Новый ОбозревательСайта1С(ИмяПользователя, ПарольПользователя);
	КонецЕсли;

	ЗаполнитьСписокЗагруженныхВерсий();

	ОбработаноВерсий = 0;

	Для Каждого ТекЭлемент Из Данные Цикл
		
		ЗаполнитьВерсии = Истина;
		
		Если ТекЭлемент.Свойство("Версии") Тогда
			ВерсииПриложения = ТекЭлемент.Версии;
			ЗаполнитьВерсии = Ложь;
		Иначе
			ВерсииПриложения = Обозреватель.ПолучитьВерсииПриложения(ТекЭлемент.Путь,
			                                                         ФильтрВерсий,
			                                                         ФильтрВерсийНачинаяСДаты,
			                                                         ФильтрВерсийДоДаты);
			
			Если ПолучатьБетаВерсии Тогда
				Для Каждого ТекБетаВерсия Из ТекЭлемент.БетаВерсии Цикл
					ВерсииПриложения.Добавить(ТекБетаВерсия);
				КонецЦикла;
			КонецЕсли;
	
		КонецЕсли;
		
		Для Каждого ТекВерсия Из ВерсииПриложения Цикл

			Если НЕ ЗагружатьВерсию(ТекВерсия.Версия) Тогда
				Лог.Информация("[%1]: Версия ""%2"" от ""%3"" конфигурации ""%4"" уже существует в каталоге ""%5""",
				               ТипЗнч(ЭтотОбъект),
				               ТекВерсия.Версия,
				               Формат(ТекВерсия.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
				               ТекВерсия.Имя,
				               КаталогДляСохранения);
				Продолжить;
			КонецЕсли;
			
			Если ЗаполнитьВерсии Тогда
				ТекВерсия.Вставить("Имя"            , ТекЭлемент.Имя);
				ТекВерсия.Вставить("Идентификатор"  , ТекЭлемент.Идентификатор);
				ТекВерсия.Вставить("ПолныйДистрибутив",
				                   Обозреватель.ЕстьСсылкаДляЗагрузки(ТекВерсия.Путь, "Полный дистрибутив$"));
				ТекВерсия.Вставить("ДистрибутивОбновления",
				                   Обозреватель.ЕстьСсылкаДляЗагрузки(ТекВерсия.Путь, "Дистрибутив обновления$"));
			КонецЕсли;

			Если ОграничениеКоличества > 0 Тогда
				Лог.Информация("[%1]: Загрузка версии %2 из %3", ТипЗнч(ЭтотОбъект), ОбработаноВерсий + 1, ОграничениеКоличества);
			КонецЕсли;

			ОбработатьВерсиюПриложения(ТекВерсия, Обозреватель);

			ОбработаноВерсий = ОбработаноВерсий + 1;

			Если ОграничениеКоличества > 0 И ОбработаноВерсий >= ОграничениеКоличества Тогда
				Лог.Информация("[%1]: Достигнут лимит загружаемых версий %2", ТипЗнч(ЭтотОбъект), ОграничениеКоличества);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;

		Если ЗаполнитьВерсии Тогда
			ТекЭлемент.Вставить("Версии", ВерсииПриложения);
		КонецЕсли;

		ПродолжениеОбработкиДанныхВызовМенеджера(ТекЭлемент);

		Если ОграничениеКоличества > 0 И ОбработаноВерсий >= ОграничениеКоличества Тогда
			Прервать;
		КонецЕсли;

	КонецЦикла;

	ЗавершениеОбработкиДанныхВызовМенеджера();

КонецПроцедуры // ОбработатьДанные()

// Функция - возвращает текущие результаты обработки
//
// Возвращаемое значение:
//	Произвольный     - результаты обработки данных
//
Функция РезультатОбработки() Экспорт
	
	Возврат Данные;
	
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
	
	Команда.Опция("af app-filter", "", "фильтр приложений")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_APP_FILTER");

	Команда.Опция("vf version-filter", "", "фильтр версий")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_VERSION_FILTER");

	Команда.Опция("vsd version-start-date", "", "фильтр по начальной дате версии (включая)")
	       .ТДата("dd.MM.yyyy")
	       .ВОкружении("YARD_RELEASES_VERSION_START_DATE");

	Команда.Опция("ved version-end-date", "", "фильтр по последней дате версии (включая)")
	       .ТДата("dd.MM.yyyy")
	       .ВОкружении("YARD_RELEASES_VERSION_END_DATE");

	Команда.Опция("df distr-filter", "", "Фильтр заголовков ссылок на скачивание дистрибутива
	                                     |если не указан, то будет выполнена проверка наличия ссылки
	                                     |""Полный дистрибутив"", затем ""Дистрибутив обновления""")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_DISTR_FILTER");

	Команда.Опция("p path", "", "каталог для загрузки релизов 1С")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_DOWNLOAD_PATH");

	Команда.Опция("de download-existing", Ложь, "Истина - будут загружены все найденные релизы
	                                            |независимо от существующих в каталоге для загрузки
	                                            |Ложь - будут загружены только отсутствующие
	                                            |в каталоге для загрузки релизы
	                                            |(проверяются файлы description.json)")
	       .Флаг();

	Команда.Опция("dl download-limit", 0, "ограничение количества загружаемых за 1 раз версий")
	       .ТЧисло()
	       .ВОкружении("YARD_RELEASES_DOWNLOAD_LIMIT");

	Команда.Опция("e extract", Ложь, "флаг распаковки загруженного архива")
	       .Флаг();

	Команда.Опция("ep extract-path", "", "каталог для распаковки загруженного архива")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_EXTRACT_PATH");

	Команда.Опция("ef extract-files", "", "список файлов для распаковки из архива дистрибутива, разделенный ""|"",
	                                      |если не указан, то распаковываются все файлы")
	       .ТСтрока()
	       .ВОкружении("YARD_RELEASES_EXTRACT_FILES");

	Команда.Опция("d delete", Ложь, "флаг удаления загруженного архива после распаковки")
		   .Флаг();
	
	Команда.Опция("bv get-beta-versions", Ложь, "флаг получения версий для ознакомления")
	       .Флаг();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ВыводОтладочнойИнформации = Команда.ЗначениеОпции("verbose");

	ПараметрыПриложения.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	УстановитьПараметрОбработкиДанных("ИмяПользователя"          , Команда.ЗначениеОпции("user"));
	УстановитьПараметрОбработкиДанных("ПарольПользователя"       , Команда.ЗначениеОпции("password"));
	
	ВремФильтрПриложений = Команда.ЗначениеОпции("app-filter");
	Служебный.УбратьКавычки(ВремФильтрПриложений);
	УстановитьПараметрОбработкиДанных("ФильтрПриложений"         , ВремФильтрПриложений);

	ВремФильтрВерсий = Команда.ЗначениеОпции("version-filter");
	Служебный.УбратьКавычки(ВремФильтрВерсий);
	УстановитьПараметрОбработкиДанных("ФильтрВерсий"             , ВремФильтрВерсий);

	УстановитьПараметрОбработкиДанных("ФильтрВерсийНачинаяСДаты" , Команда.ЗначениеОпции("version-start-date"));
	УстановитьПараметрОбработкиДанных("ФильтрВерсийДоДаты"       , Команда.ЗначениеОпции("version-end-date"));

	ВремФильтрДистрибутива = Команда.ЗначениеОпции("distr-filter");
	Служебный.УбратьКавычки(ВремФильтрДистрибутива);
	УстановитьПараметрОбработкиДанных("ФильтрДистрибутива"       , ВремФильтрДистрибутива);

	УстановитьПараметрОбработкиДанных("КаталогДляСохранения"     , Команда.ЗначениеОпции("path"));
	УстановитьПараметрОбработкиДанных("ЗагружатьСуществующие"    , Команда.ЗначениеОпции("download-existing"));
	УстановитьПараметрОбработкиДанных("ОграничениеКоличества"    , Команда.ЗначениеОпции("download-limit"));
	УстановитьПараметрОбработкиДанных("РаспаковыватьEFD"         , Команда.ЗначениеОпции("extract"));
	УстановитьПараметрОбработкиДанных("КаталогДляРаспаковкиEFD"  , Команда.ЗначениеОпции("extract-path"));
	УстановитьПараметрОбработкиДанных("УдалитьПослеРаспаковкиEFD", Команда.ЗначениеОпции("delete"));
	УстановитьПараметрОбработкиДанных("ПолучатьБетаВерсии"       , Команда.ЗначениеОпции("get-beta-versions"));

	ВремФайлы = СтрРазделить(Команда.ЗначениеОпции("extract-files"), "|", Ложь);
	УстановитьПараметрОбработкиДанных("ФайлыДляРаспаковкиEFD"    , ВремФайлы);

	Обозреватель = Новый ОбозревательСайта1С(ИмяПользователя, ПарольПользователя);

	Данные = Обозреватель.ПолучитьСписокПриложений(ФильтрПриложений);

	ОбработатьДанные(Обозреватель);

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

// Процедура - выполняет загрузку и распаковку версии приложения
//
// Параметры:
//	ОписаниеВерсии           - Структура          - описание версии приложения
//      *Идентификатор          - Строка              - идентификатор приложения
//      *Имя                    - Строка              - имя приложения
//      *Версия                 - Строка              - номер версии приложения
//      *Дата                   - Дата                - дата версии приложения
//      *ПолныйДистрибутив      - Булево              - версия содержит полный дистрибутив
//      *ДистрибутивОбновления  - Булево              - версия содержит дистрибутив обновления
//      *ВерсииДляОбновления    - Массив(Строка)      - массив номеров версий, для которых преднозначено обновление
//	Обозреватель             - Объект             - экземпляр класса "Обозреватель1С"
//
Процедура ОбработатьВерсиюПриложения(ОписаниеВерсии, Обозреватель = Неопределено)

	Если Обозреватель = Неопределено Тогда
		Обозреватель = Новый ОбозревательСайта1С(ИмяПользователя, ПарольПользователя);
	КонецЕсли;

	Если ЗначениеЗаполнено(ФильтрДистрибутива) Тогда
		ШаблонСсылки = ФильтрДистрибутива;
	ИначеЕсли ОписаниеВерсии.ПолныйДистрибутив Тогда
		ШаблонСсылки = "Полный дистрибутив$";
	ИначеЕсли ОписаниеВерсии.ДистрибутивОбновления Тогда
		ШаблонСсылки = "Дистрибутив обновления$";
	Иначе
		Возврат;
	КонецЕсли;

	СписокСсылок = Обозреватель.ПолучитьСсылкиДляЗагрузки(ОписаниеВерсии.Путь, ШаблонСсылки);

	Для Каждого ТекСсылка Из СписокСсылок Цикл

		ИмяФайлаАрхива = ОбъединитьПути(КаталогДляСохранения,
		                                ОписаниеВерсии.Идентификатор,
		                                ОписаниеВерсии.Версия,
		                                ТекСсылка.ИмяФайла);

		ФайлАрхива = Новый Файл(ИмяФайлаАрхива);

		Распаковщик.ОбеспечитьКаталог(ИмяФайлаАрхива, Истина);

		Лог.Информация("[%1]: Начало загрузки ""%2"", версия ""%3"": %4 (%5) в файл %6.",
	                   СокрЛП(ЭтотОбъект),
	                   ОписаниеВерсии.Имя,
	                   ОписаниеВерсии.Версия,
	                   ТекСсылка.Имя,
	                   ТекСсылка.ПутьДляЗагрузки,
	                   ИмяФайлаАрхива);

		Обозреватель.ЗагрузитьФайл(ТекСсылка.ПутьДляЗагрузки, ИмяФайлаАрхива);

		Лог.Информация("[%1]: Загружен файл ""%2""", СокрЛП(ЭтотОбъект), ИмяФайлаАрхива);

		Распаковщик.РаспаковатьАрхив(ИмяФайлаАрхива, ФайлАрхива.Путь);
		
		Лог.Информация("[%1]: Распакован файл ""%2""", СокрЛП(ЭтотОбъект), ИмяФайлаАрхива);

		УдалитьФайлы(ИмяФайлаАрхива);
		
		Лог.Информация("[%1]: Удален файл ""%2""", СокрЛП(ЭтотОбъект), ИмяФайлаАрхива);

		Если ФайлАрхива.Расширение = ".gz" Тогда
			ИмяВложенногоФайлаАрхива = СтрШаблон("%1%2", ФайлАрхива.Путь, ФайлАрхива.ИмяБезРасширения);
			ВложенныйФайлАрхива = Новый Файл(ИмяВложенногоФайлаАрхива);

			Если ВложенныйФайлАрхива.Существует() Тогда

				Распаковщик.РаспаковатьАрхив(ИмяВложенногоФайлаАрхива, ВложенныйФайлАрхива.Путь);

				Лог.Информация("[%1]: Распакован файл ""%2""", СокрЛП(ЭтотОбъект), ИмяВложенногоФайлаАрхива);

				УдалитьФайлы(ИмяВложенногоФайлаАрхива);
				
				Лог.Информация("[%1]: Удален файл ""%2""", СокрЛП(ЭтотОбъект), ИмяВложенногоФайлаАрхива);
		
			КонецЕсли;
		
		КонецЕсли;

		ЗаписатьОписаниеВерсииВФайл(ОписаниеВерсии, ФайлАрхива.Путь);

		ФайлАрхиваEFD = Новый Файл(ОбъединитьПути(ФайлАрхива.Путь, "1cv8.efd"));

		ОписаниеВерсии.Вставить("ЭтоКонфигурация", ФайлАрхиваEFD.Существует());
		
		Если ОписаниеВерсии.ЭтоКонфигурация И РаспаковыватьEFD Тогда

			РаспаковщикРелиза = Новый РаспаковщикРелизов1С();
			РаспаковщикРелиза.УстановитьПараметрыОбработкиДанных(ПараметрыОбработки);
			РаспаковщикРелиза.УстановитьПараметрОбработкиДанных("Приложение_Имя"         , ОписаниеВерсии.Имя);
			РаспаковщикРелиза.УстановитьПараметрОбработкиДанных("Приложение_Ид"          , ОписаниеВерсии.Идентификатор);
			РаспаковщикРелиза.УстановитьПараметрОбработкиДанных("Приложение_Версия"      , ОписаниеВерсии.Версия);
			РаспаковщикРелиза.УстановитьПараметрОбработкиДанных("ПутьКДистрибутиву"      , ФайлАрхива.Путь);
			РаспаковщикРелиза.УстановитьПараметрОбработкиДанных("КаталогДляРаспаковкиEFD", КаталогДляРаспаковкиEFD);
			РаспаковщикРелиза.ОбработатьДанные();

			Если УдалитьПослеРаспаковкиEFD Тогда
				УдалитьФайлы(ФайлАрхива.Путь, "*.*");
				УдалитьФайлы(ФайлАрхива.Путь);
				Лог.Информация("[%1]: Удален дистрибутив ""%2""", СокрЛП(ЭтотОбъект), ФайлАрхива.Путь);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ОбработатьВерсиюПриложения()

// Процедура - записывает описание версии в файл JSON
//
// Параметры:
//	ОписаниеВерсии         - Структура     - описание версии приложения
//      *Идентификатор        - Строка         - идентификатор приложения
//      *Имя                  - Строка         - имя приложения
//      *Версия               - Строка         - номер версии приложения
//      *Дата                 - Дата           - дата версии приложения
//      *ВидДистрибутива      - Строка         - вид дистрибутива "Полный"/"Обновление"
//      *ВерсииДляОбновления  - Массив(Строка) - массив номеров версий, для которых преднозначено обновление
//	Путь                   - Строка        - путь к каталогу, в котором будет сохранен файл описания версии
//
Процедура ЗаписатьОписаниеВерсииВФайл(Знач ОписаниеВерсии, Знач Путь)

	ПутьКФайлуОписания = ОбъединитьПути(Путь, "description.json");

	Распаковщик.ОбеспечитьКаталог(ПутьКФайлуОписания, Истина);
	
	Запись = Новый ЗаписьJSON();
	
	Запись.ОткрытьФайл(ПутьКФайлуОписания, "UTF-8", , Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix, Символы.Таб));
	
	Лог.Информация("[%1]: Запись описания версии в файл ""%2""", ТипЗнч(ЭтотОбъект), ПутьКФайлуОписания);

	Попытка
		ЗаписатьJSON(Запись, ОписаниеВерсии);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Запись.Закрыть();

КонецПроцедуры // ЗаписатьОписаниеВерсииВФайл()

Процедура ЗаполнитьСписокЗагруженныхВерсий()
	
	ФайлыОписанийВерсий = НайтиФайлы(КаталогДляСохранения, "description.json", Истина);

	ЗагруженныеВерсии = Новый Соответствие();

	Для Каждого ТекФайл Из ФайлыОписанийВерсий Цикл

		ОписаниеВерсии = Служебный.ОписаниеРелиза(ТекФайл.ПолноеИмя);

		ЗагруженныеВерсии.Вставить(ОписаниеВерсии.Версия, Истина);

	КонецЦикла;

КонецПроцедуры // ЗаполнитьСписокЗагруженныхВерсий()

Функция ЗагружатьВерсию(Версия)
	
	Если ЗагружатьСуществующие Тогда
		Возврат Истина;
	КонецЕсли;

	Возврат НЕ ЗагруженныеВерсии.Получить(Версия) = Истина;

КонецФункции // ЗагружатьВерсию()

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
