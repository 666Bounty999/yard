

Функция Авторизация(Знач Сервер, Знач Имя, Знач Пароль, Знач АдресРесурса = "")
		
	КодПереадресации = 302;

	// для GET-запросов
	ЗапросПолучение = Новый HTTPЗапрос;
	ЗапросПолучение.Заголовки.Вставить("User-Agent", "oscript");
	ЗапросПолучение.Заголовки.Вставить("Connection", "keep-alive");
	
	// для POST-запросов
	ЗапросОбработка = Новый HTTPЗапрос;
	ЗапросОбработка.Заголовки.Вставить("User-Agent", "oscript");
	ЗапросОбработка.Заголовки.Вставить("Connection", "keep-alive");
	ЗапросОбработка.Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	
	СоединениеРегистрации = Новый HTTPСоединение("https://login.1c.ru", , , , , 20);
	СоединениеРегистрации.РазрешитьАвтоматическоеПеренаправление = Ложь;

	СоединениеЦелевое = Новый HTTPСоединение(Сервер, , , , , 20);
	СоединениеЦелевое.РазрешитьАвтоматическоеПеренаправление = Ложь;
	
	// Запрос 1
	ЗапросПолучение.АдресРесурса = АдресРесурса;
	
	// Ответ 1 - переадресация на страницу регистрации
	ОтветПереадресация = СоединениеЦелевое.Получить(ЗапросПолучение);
	ИдСеанса = ОтветПереадресация.Заголовки.Получить("Set-Cookie");
	ИдСеанса = Лев(ИдСеанса, Найти(ИдСеанса, ";") - 1);
	
	// Запрос 2 - переходим на страницу регистрации
	ЗапросПолучение.АдресРесурса = СтрЗаменить(ОтветПереадресация.Заголовки.Получить("Location"), "https://login.1c.ru", "");
	
	// Ответ 2 - получение строки регистрации
	ОтветРегистрация = СоединениеРегистрации.Получить(ЗапросПолучение);
	СтрокаРегистрации = ПолучитьСтрокуРегистрации(ОтветРегистрация.ПолучитьТелоКакСтроку(), Имя, Пароль);

	// Запрос 3 - выполнение регистрации
	ЗапросОбработка.АдресРесурса = "/login";
	ЗапросОбработка.Заголовки.Вставить("Cookie", ИдСеанса + "; i18next=ru-RU");
	ЗапросОбработка.УстановитьТелоИзСтроки(СтрокаРегистрации);

	// Ответ 3 - проверка успешности регистрации
	ОтветПроверка = СоединениеРегистрации.ОтправитьДляОбработки(ЗапросОбработка);
	
	Если ОтветПроверка.КодСостояния <> КодПереадресации Тогда
		
		ВызватьИсключение "Что-то пошло не так!";
		
	КонецЕсли;
	
	// Запрос 4 - переход на целевую страницу
	ЗапросПолучение.АдресРесурса = СтрЗаменить(ОтветПроверка.Заголовки.Получить("Location"), Сервер, "");
	ЗапросПолучение.Заголовки.Вставить("Cookie", ИдСеанса);
	
	СоединениеЦелевое.Получить(ЗапросПолучение);
		
	Возврат ИдСеанса;
	
КонецФункции // Авторизация()

&НаСервере
Функция ПолучитьСтрокуРегистрации(Знач Текст, Знач Имя, Знач Пароль)
	
	Шаблон = "<input type=""hidden"" name=""execution"" value=""(.*)""\/><input type=""hidden"" name=""_eventId""";
	РВ = Новый РегулярноеВыражение(Шаблон);
	Совпадения = РВ.НайтиСовпадения(Текст);

	execution = "";
	Если Совпадения.Количество() > 0 Тогда
		execution = Совпадения[0].Группы[1].Значение;
	КонецЕсли;

	СтрокаРегистрации = "inviteCode=&username=" + Имя 
	                  + "&password=" + Пароль
	                  + "&execution=" + execution
	                  + "&_eventId=submit"
	                  + "&geolocation="
	                  + "&submit=Войти"
	                  + "&rememberMe=on";
				
	Возврат СтрокаРегистрации;
	
КонецФункции // ПолучитьСтрокуРегистрации()

Функция ПолучитьСписокКонфигураций(Знач ИдСеанса, Знач Фильтр = Неопределено)
	
	СтраницаКонфигураций = ПолучитьСтраницуСайта("https://releases.1c.ru", "/total", ИдСеанса);
	
	РВ = Новый РегулярноеВыражение("<td class=""nameColumn"">\s*<a href=""(.*)"">(.*)<\/a>");
	Совпадения = РВ.НайтиСовпадения(СтраницаКонфигураций);
	
	СписокКонфигураций = Новый Массив();
	Если Совпадения.Количество() > 0 Тогда
		Для Каждого ТекСовпадение Из Совпадения Цикл
			Если ТекСовпадение.Группы.Количество() < 3 Тогда
				Продолжить;
			КонецЕсли;

			ТекИмя = ТекСовпадение.Группы[2].Значение;

			Если НЕ СоответствуетФильтру(ТекИмя, Фильтр) Тогда
				Продолжить;
			КонецЕсли;

			ТекКонфигурация = Новый Структура("Имя, Путь",
											  ТекИмя,
											  ТекСовпадение.Группы[1].Значение);
			СписокКонфигураций.Добавить(ТекКонфигурация);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокКонфигураций;
	
КонецФункции // ПолучитьСписокКонфигураций()

Функция ПолучитьВерсииКонфигурации(Знач АдресРесурса, Знач ИдСеанса, Знач Фильтр = Неопределено)
	
	СтраницаВерсий = ПолучитьСтраницуСайта("https://releases.1c.ru", АдресРесурса, ИдСеанса);
	
	Шаблон = "<td class=""versionColumn"">\s*<a href=""(.*)"">\s*(.*)\s*<\/a>(\s|.)*?"
		   + "<td class=""dateColumn"">\s*(.*)\s*<\/td>(\s|.)*?"
		   + "<td class=""version previousVersionsColumn"">\s*(.*)\s*<\/td>";
	РВ = Новый РегулярноеВыражение(Шаблон);
	Совпадения = РВ.НайтиСовпадения(СтраницаВерсий);
	
	СписокВерсий = Новый Массив();
	Если Совпадения.Количество() > 0 Тогда
		Для Каждого ТекСовпадение Из Совпадения Цикл
			Если ТекСовпадение.Группы.Количество() < 3 Тогда
				Продолжить;
			КонецЕсли;

			ТекНомерВерсии = ТекСовпадение.Группы[2].Значение;

			Если НЕ СоответствуетФильтру(ТекНомерВерсии, Фильтр) Тогда
				Продолжить;
			КонецЕсли;

			ТекВерсия = Новый Структура("Версия, Дата, Путь, ВерсииДляОбновления");
			ТекВерсия.Версия              = ТекНомерВерсии;
			ТекВерсия.Дата                = ТекСовпадение.Группы[4].Значение;
			ТекВерсия.Путь                = ТекСовпадение.Группы[1].Значение;
			ТекВерсия.ВерсииДляОбновления = СтрРазделить(ТекСовпадение.Группы[6].Значение, ",", Ложь);
			СписокВерсий.Добавить(ТекВерсия);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокВерсий;
	
КонецФункции // ПолучитьВерсииКонфигурации()

Функция ПолучитьСсылкиДляЗагрузки(Знач АдресРесурса = "", Знач ИдСеанса = "", Знач Фильтр = Неопределено)
	
	СтраницаВерсии = ПолучитьСтраницуСайта("https://releases.1c.ru", АдресРесурса, ИдСеанса);

	Шаблон = "<div class=""formLine"">\s*<a href=""(.*)"">\s*(.*)\s*<\/a>(\s|.)*?<\/div>";
	РВ = Новый РегулярноеВыражение(Шаблон);
	Совпадения = РВ.НайтиСовпадения(СтраницаВерсии);
	
	СписокСсылок = Новый Массив();
	Если Совпадения.Количество() > 0 Тогда

		Для Каждого ТекСовпадение Из Совпадения Цикл

			Если ТекСовпадение.Группы.Количество() < 3 Тогда
				Продолжить;
			КонецЕсли;

			ТекИмя = ТекСовпадение.Группы[2].Значение;
			ТекСсылка = ТекСовпадение.Группы[1].Значение;

			Если НЕ СоответствуетФильтру(ТекИмя, Фильтр) Тогда
				Продолжить;
			КонецЕсли;

			СтраницаЗагрузки = ПолучитьСтраницуСайта("https://releases.1c.ru", ТекСсылка, ИдСеанса);
			
			Шаблон = "<div class=""downloadDist"">(\s|.)*?<a href=""(.*)"">\s*Скачать дистрибутив\s*<\/a>(\s|.)*?<\/div>";
			РВ = Новый РегулярноеВыражение(Шаблон);
			СовпаденияДляЗагрузки = РВ.НайтиСовпадения(СтраницаЗагрузки);
			
			Если СовпаденияДляЗагрузки.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;

			ТекВерсия = Новый Структура("Имя, Путь, ПутьДляЗагрузки");
			ТекВерсия.Имя             = ТекИмя;
			ТекВерсия.Путь            = ТекСсылка;
			ТекВерсия.ПутьДляЗагрузки = СовпаденияДляЗагрузки[0].Группы[2].Значение;
			СписокСсылок.Добавить(ТекВерсия);

		КонецЦикла;
	КонецЕсли;

	Возврат СписокСсылок;

КонецФункции // ПолучитьСсылкиДляЗагрузки()

Функция ПолучитьСтраницуСайта(Знач Сервер, Знач АдресРесурса, Знач ИдСеанса, Знач АвтоматическоеПеренаправление = Ложь)
	
	Соединение = Новый HTTPСоединение(Сервер, , , , , 20);
	Соединение.РазрешитьАвтоматическоеПеренаправление = АвтоматическоеПеренаправление;

	Запрос = Новый HTTPЗапрос;
	Запрос.Заголовки.Вставить("User-Agent", "oscript");
	Запрос.Заголовки.Вставить("Connection", "keep-alive");
	Запрос.Заголовки.Вставить("Cookie", ИдСеанса);
	Запрос.АдресРесурса = АдресРесурса;
	
	Ответ = Соединение.Получить(Запрос);

	Возврат Ответ.ПолучитьТелоКакСтроку();

КонецФункции // ПолучитьСтраницуСайта()

Функция ЗагрузитьФайл(АдресИсточника, Знач Имя, Знач Пароль, Знач ИмяФайлаДляСохранения)
	
	СтруктураАдреса = СтруктураURI(АдресИсточника);
	
	Сервер = СтрШаблон("%1://%2", СтруктураАдреса.Схема, СтруктураАдреса.Хост);
	
	ИдСеанса = Авторизация(Сервер, Имя, Пароль, СтруктураАдреса.ПутьНаСервере);

	Соединение = Новый HTTPСоединение(Сервер, , , , , 20);
	Соединение.РазрешитьАвтоматическоеПеренаправление = Истина;

	Запрос = Новый HTTPЗапрос;
	Запрос.Заголовки.Вставить("User-Agent", "oscript");
	Запрос.Заголовки.Вставить("Connection", "keep-alive");
	Запрос.Заголовки.Вставить("Cookie", ИдСеанса);
	Запрос.АдресРесурса = АдресИсточника;
	Ответ = Соединение.Получить(Запрос);

	ДанныеФайла = Ответ.ПолучитьТелоКакДвоичныеДанные();
	ДанныеФайла.Записать(ИмяФайлаДляСохранения);

	Возврат Истина;

КонецФункции // ПолучитьСтраницуСайта()

Функция ПолучитьИмяФайлаИзАдреса(Знач АдресФайла)

	ИмяФайла = АдресФайла;
	Поз = Найти(ИмяФайла, "\");
	Пока Поз > 0 Цикл
		ИмяФайла = Сред(ИмяФайла, Поз + 1);
		Поз = Найти(ИмяФайла, "\");
	КонецЦикла;

	Возврат ИмяФайла;

КонецФункции // ПолучитьИмяФайлаИзАдреса()

Функция СоответствуетФильтру(Знач Значение, Знач Фильтр)

	Если Фильтр = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;

	МассивФильтров = Новый Массив();

	Если ТипЗнч(Фильтр) = Тип("Строка") Тогда
		МассивФильтров.Добавить(Фильтр);
	ИначеЕсли ТипЗнч(Фильтр) = Тип("Массив") Тогда
		МассивФильтров = Фильтр;
	Иначе
		Возврат Ложь;
	КонецЕсли;

	СоответствуетФильтру = Ложь;

	Для Каждого ТекФильтр Из МассивФильтров Цикл
		
		Если НЕ ТипЗнч(Фильтр) = Тип("Строка") Тогда
			Продолжить;
		КонецЕсли;

		РВ = Новый РегулярноеВыражение(ТекФильтр);
		Совпадения = РВ.НайтиСовпадения(Значение);
	
		Если Совпадения.Количество() > 0 Тогда
			СоответствуетФильтру = Истина;
			Прервать;
		КонецЕсли;

	КонецЦикла;

	Возврат СоответствуетФильтру;

КонецФункции // СоответствуетФильтру()

Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = Найти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;

	// строка соединения и путь на сервере
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = Найти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
		
	// информация пользователя и имя сервера
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = Найти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = Найти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = Найти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(Порт <> "", Число(Порт), Неопределено));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

Имя = АргументыКоманднойСтроки[0];
Пароль = АргументыКоманднойСтроки[1];

ФильтрКонфигураций = "ERP Управление предприятием";
ФильтрВерсий = "2\.4\.11";
ФильтрЗагрузок = "Полный дистрибутив";

ИдСеанса = Авторизация("https://releases.1c.ru", Имя, Пароль, "/total");

СписокКонфигураций = ПолучитьСписокКонфигураций(ИдСеанса, ФильтрКонфигураций);

Для Каждого ТекКонфигурация Из СписокКонфигураций Цикл
	Сообщить(СтрШаблон("%1 : %2", ТекКонфигурация.Имя, ТекКонфигурация.Путь));
	СписокВерсий = ПолучитьВерсииКонфигурации(ТекКонфигурация.Путь, ИдСеанса, ФильтрВерсий);
	Для Каждого ТекВерсия Из СписокВерсий Цикл
		Сообщить(СтрШаблон("%1 %2 : %3 : %4", Символы.Таб, ТекВерсия.Версия, ТекВерсия.Дата, ТекВерсия.Путь));
		СписокСсылок = ПолучитьСсылкиДляЗагрузки(ТекВерсия.Путь, ИдСеанса, ФильтрЗагрузок);
		Для Каждого ТекСсылка Из СписокСсылок Цикл
			Сообщить(СтрШаблон("%1%1 %2 : %3 (Скачать: %4)",
							   Символы.Таб,
							   ТекСсылка.Имя,
							   ТекСсылка.Путь,
							   ТекСсылка.ПутьДляЗагрузки));
			ИмяФайла = ПолучитьИмяФайлаИзАдреса(ТекСсылка.Путь);
			ИмяФайла = ОбъединитьПути(ТекущийКаталог(), ИмяФайла);
			ЗагрузитьФайл(ТекСсылка.ПутьДляЗагрузки, Имя, Пароль, ИмяФайла);
		КонецЦикла;
		Для Каждого ТекВерсияО Из ТекВерсия.ВерсииДляОбновления Цикл
			Сообщить(СтрШаблон("%1%1 %2", Символы.Таб, СокрЛП(ТекВерсияО)));
		КонецЦикла;
	КонецЦикла;
КонецЦикла;