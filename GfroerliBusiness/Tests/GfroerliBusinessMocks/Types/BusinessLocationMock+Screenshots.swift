//
//  BusinessLocationMock+Screenshots.swift
//  GfroerliBusiness
//
//  Handmade fixture data used to populate the app with deterministic locations for App Store
//  screenshots (see the `-uiScreenshots` launch mode). Mirrors the shape of the server response.
//

import Foundation
import GfroerliBusinessProtocols

public extension BusinessLocationMock {

    /// Convenience initializer for screenshot fixtures: derives the display strings from the raw
    /// values so only the server-shaped fields need to be provided. Formatting matches the real
    /// `MeasurementHelper` (1 fraction digit, localized unit / date).
    init(
        id: Int,
        name: String,
        shortName: String,
        description: String?,
        latitude: Double,
        longitude: Double,
        creationDate: Date,
        sponsorID: Int?,
        lastTemperature: Double,
        lastTemperatureDate: Date,
        highestTemperature: Double? = nil,
        lowestTemperature: Double? = nil,
        averageTemperature: Double? = nil,
        isActive: Bool = true
    ) {
        let tempFormatter = MeasurementFormatter()
        tempFormatter.numberFormatter.minimumFractionDigits = 1
        tempFormatter.numberFormatter.maximumFractionDigits = 1
        tempFormatter.unitStyle = .medium
        // Always display Celsius; don't let the locale convert to Fahrenheit (e.g. en-US).
        tempFormatter.unitOptions = .providedUnit

        func tempString(_ value: Double?) -> String {
            guard let value else { return "" }
            return tempFormatter.string(from: Measurement<UnitTemperature>(value: value, unit: .celsius))
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        self.init(
            id: id,
            name: name,
            shortName: shortName,
            description: description,
            latitude: latitude,
            longitude: longitude,
            creationDate: creationDate,
            sponsorID: sponsorID,
            lastTemperature: lastTemperature,
            lastTemperatureString: tempString(lastTemperature),
            lastTemperatureDate: lastTemperatureDate,
            lastTemperatureDateString: dateFormatter.string(from: lastTemperatureDate),
            highestTemperature: highestTemperature,
            highestTemperatureString: tempString(highestTemperature),
            lowestTemperature: lowestTemperature,
            lowestTemperatureString: tempString(lowestTemperature),
            averageTemperature: averageTemperature,
            averageTemperatureString: tempString(averageTemperature),
            isActive: isActive
        )
    }

    /// The full set of real-world Gfrör.li locations, used to populate the map / search / detail
    /// screens for App Store screenshots without hitting the server.
    static let screenshotLocations: [BusinessLocationMock] = [
        BusinessLocationMock(id: 1, name: "Rapperswil, OST", shortName: "OST", description: "Die beliebte Liegewiese direkt hinter der Hochschule.", latitude: 47.222207, longitude: 8.815783, creationDate: Date(timeIntervalSinceReferenceDate: 502144521.0), sponsorID: 1, lastTemperature: 26.8, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805896092.0)),
        BusinessLocationMock(id: 6, name: "Kempraten", shortName: "KEM", description: "Die Wassertemperatur in Kempraten.", latitude: 47.2334, longitude: 8.81696, creationDate: Date(timeIntervalSinceReferenceDate: 665958071.0), sponsorID: 5, lastTemperature: 27.9, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993937.0)),
        BusinessLocationMock(id: 7, name: "Pfäffikon SZ", shortName: "PÄF", description: "Die Wassertemperatur bei der Seebadi.", latitude: 47.208, longitude: 8.776, creationDate: Date(timeIntervalSinceReferenceDate: 675685289.0), sponsorID: 5, lastTemperature: 26.8, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993129.0)),
        BusinessLocationMock(id: 9, name: "Strandbad Tribschen", shortName: "TRIB", description: "Die gemütliche Badi in Luzern mit Panoramablick.", latitude: 47.0401, longitude: 8.3307, creationDate: Date(timeIntervalSinceReferenceDate: 679474917.0), sponsorID: 5, lastTemperature: 7.9, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 787268827.0)),
        BusinessLocationMock(id: 10, name: "Cham", shortName: "CHA", description: "Temperatur im Zugersee bei Cham", latitude: 47.17975, longitude: 8.4687, creationDate: Date(timeIntervalSinceReferenceDate: 773517514.0), sponsorID: 7, lastTemperature: 25.3, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805953487.0)),
        BusinessLocationMock(id: 12, name: "Baden, Limmat", shortName: "BAD", description: "Die Temperatur der Limmat, gemessen beim Limmatsteg.", latitude: 47.475635, longitude: 8.309816, creationDate: Date(timeIntervalSinceReferenceDate: 774042838.0), sponsorID: 6, lastTemperature: 26.15, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993608.0)),
        BusinessLocationMock(id: 13, name: "Weesen, Linth", shortName: "WEE", description: "Die Temperatur der Linth, gemessen im Quartier \"Biäsche\".", latitude: 47.131464, longitude: 9.088613, creationDate: Date(timeIntervalSinceReferenceDate: 774102962.0), sponsorID: 6, lastTemperature: 21.71, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993608.0)),
        BusinessLocationMock(id: 14, name: "Mollis, Linth", shortName: "MOL", description: "Die Temperatur der Linth, gemessen bei der Linthbrücke.", latitude: 47.1011, longitude: 9.0718, creationDate: Date(timeIntervalSinceReferenceDate: 774191900.0), sponsorID: 6, lastTemperature: 15.33, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993608.0)),
        BusinessLocationMock(id: 15, name: "Zürich, Sihl", shortName: "SIH", description: "Die Temperatur der Sihl, gemessen beim Sihlhölzli.", latitude: 47.3676, longitude: 8.5262, creationDate: Date(timeIntervalSinceReferenceDate: 774191991.0), sponsorID: 6, lastTemperature: 25.03, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993608.0)),
        BusinessLocationMock(id: 16, name: "Bern, Aare", shortName: "BER", description: "Die Temperatur der Aare, gemessen beim Tierpark Dälhölzli.", latitude: 46.9332, longitude: 7.4482, creationDate: Date(timeIntervalSinceReferenceDate: 774192096.0), sponsorID: 6, lastTemperature: 23.01, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805994214.0), highestTemperature: 24.82, lowestTemperature: 4.12, averageTemperature: 12.505093230477378),
        BusinessLocationMock(id: 18, name: "Brienzwiler, Aare", shortName: "BRW", description: "Die Temperatur der Aare, gemessen in Brienzwiler beim Bahnhof.", latitude: 46.745476, longitude: 8.0923, creationDate: Date(timeIntervalSinceReferenceDate: 774216111.0), sponsorID: 6, lastTemperature: 11.8, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993608.0)),
        BusinessLocationMock(id: 19, name: "Brugg, Aare", shortName: "BRU", description: "Die Temperatur der Aare, gemessen in Brugg.", latitude: 47.482768, longitude: 8.194143, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 24.57, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993608.0)),
        BusinessLocationMock(id: 20, name: "Brügg, Aare", shortName: "BRÜ", description: "Die Temperatur der Aare, gemessen in Brügg bei Biel.", latitude: 47.12241, longitude: 7.283117, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 25.09, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993608.0)),
        BusinessLocationMock(id: 21, name: "Felsenau, Aare", shortName: "FEL", description: "Die Temperatur der Aare, gemessen in Brienzwiler beim Kraftwerk Klingnau.", latitude: 47.594942, longitude: 8.223878, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 25.13, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993910.0)),
        BusinessLocationMock(id: 22, name: "Hagneck, Aare", shortName: "HAG", description: "Die Temperatur der Aare, gemessen in Hagneck.", latitude: 47.055428, longitude: 7.183927, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 24.05, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993002.0)),
        BusinessLocationMock(id: 23, name: "Interlaken, Aare", shortName: "INT", description: "Die Temperatur der Aare, gemessen in Interlaken.", latitude: 46.693762, longitude: 7.8804, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 17.5, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993002.0)),
        BusinessLocationMock(id: 24, name: "Thun, Aare", shortName: "THN", description: "Die Temperatur der Aare, gemessen in Thun.", latitude: 46.764534, longitude: 7.612238, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 22.54, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993002.0)),
        BusinessLocationMock(id: 25, name: "St. Sulpice, Areuse", shortName: "SSU", description: "Die Temperatur der Areuse, gemessen in St. Sulpice.", latitude: 46.910349, longitude: 6.559103, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 11.23, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993002.0)),
        BusinessLocationMock(id: 26, name: "Genf, Arve", shortName: "GEN", description: "Die Temperatur der Arve, gemessen in Genf.", latitude: 46.180315, longitude: 6.159704, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 13.08, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993002.0)),
        BusinessLocationMock(id: 27, name: "Biberbrugg, Biber", shortName: "BIB", description: "Die Temperatur der Biber, gemessen in Biberbrugg.", latitude: 47.153316, longitude: 8.721085, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 21.63, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993002.0)),
        BusinessLocationMock(id: 28, name: "Münchenstein, Birs", shortName: "MUN", description: "Die Temperatur der Birs, gemessen in Münchenstein.", latitude: 47.518213, longitude: 7.618922, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 22.6, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993002.0)),
        BusinessLocationMock(id: 29, name: "Payerne, Broye", shortName: "PAY", description: "Die Temperatur der Broye, gemessen in Payerne.", latitude: 46.835853, longitude: 6.936474, creationDate: Date(timeIntervalSinceReferenceDate: 774216120.0), sponsorID: 6, lastTemperature: 24.77, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993002.0)),
        BusinessLocationMock(id: 30, name: "Ocourt, Doubs", shortName: "OCO", description: "Die Temperatur des Doubs, gemessen in Ocourt.", latitude: 47.350616, longitude: 7.075954, creationDate: Date(timeIntervalSinceReferenceDate: 774216121.0), sponsorID: 6, lastTemperature: 23.42, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 31, name: "Emmenmatt, Emme", shortName: "EMM", description: "Die Temperatur der Emme, gemessen bei Emmenmatt.", latitude: 46.9545, longitude: 7.749, creationDate: Date(timeIntervalSinceReferenceDate: 774474161.0), sponsorID: 6, lastTemperature: 21.96, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 32, name: "Huttwil, Langete", shortName: "HUT", description: "Die Temperatur der Langete, gemessen bei Häbernbad nördlich von Huttwil.", latitude: 47.1226, longitude: 7.8283, creationDate: Date(timeIntervalSinceReferenceDate: 774474251.0), sponsorID: 6, lastTemperature: 17.96, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 33, name: "Rheinsfelden, Glatt", shortName: "RHF", description: "Die Temperatur der Glatt, gemessen kurz vor der Mündung in den Rhein.", latitude: 47.5734, longitude: 8.4758, creationDate: Date(timeIntervalSinceReferenceDate: 774474462.0), sponsorID: 6, lastTemperature: 23.66, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 34, name: "Rekingen, Rhein", shortName: "REK", description: "Die Temperatur des Rheins, gemessen in Rekingen.", latitude: 47.5706, longitude: 8.3296, creationDate: Date(timeIntervalSinceReferenceDate: 774474537.0), sponsorID: 6, lastTemperature: 25.32, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 35, name: "Weil, Rhein", shortName: "WEI", description: "Die Temperatur des Rheins, gemessen bei der Palmrainbrücke.", latitude: 47.6013, longitude: 7.5937, creationDate: Date(timeIntervalSinceReferenceDate: 774474618.0), sponsorID: 6, lastTemperature: 25.19, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 36, name: "Wilderswil, Lütschine", shortName: "WIL", description: "Die Temperatur der Lütschine, gemessen bei Gsteig.", latitude: 46.6642, longitude: 7.8715, creationDate: Date(timeIntervalSinceReferenceDate: 774474921.0), sponsorID: 6, lastTemperature: 10.14, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 37, name: "Oberwald, Rhone", shortName: "OBW", description: "Die Temperatur der Rhone, gemessen bei Oberwald.", latitude: 46.5344, longitude: 8.3492, creationDate: Date(timeIntervalSinceReferenceDate: 774475016.0), sponsorID: 6, lastTemperature: 7.5, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 38, name: "Emmenbrücke, Kleine Emme", shortName: "EMM", description: "Die Temperatur der Kleinen Emme, gemessen in Emmenbrücke kurz vor der Mündung in die Reuss.", latitude: 47.070781, longitude: 8.276968, creationDate: Date(timeIntervalSinceReferenceDate: 775056102.0), sponsorID: 6, lastTemperature: 25.1, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 39, name: "Luzern, Reuss", shortName: "LUZ", description: "Die Temperatur der Reuss, gemessen in Luzern bei der Geissmattbrücke.", latitude: 47.0539, longitude: 8.2984, creationDate: Date(timeIntervalSinceReferenceDate: 775056181.0), sponsorID: 6, lastTemperature: 24.5, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993003.0)),
        BusinessLocationMock(id: 40, name: "Seedorf, Reuss", shortName: "SDO", description: "Die Temperatur der Reuss, gemessen in Seedorf.", latitude: 46.8842, longitude: 8.6207, creationDate: Date(timeIntervalSinceReferenceDate: 775056277.0), sponsorID: 6, lastTemperature: 14.14, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993306.0)),
        BusinessLocationMock(id: 43, name: "Buochs, Engelberger Aa", shortName: "BUO", description: "Die Temperatur der Engelberger Aa, gemessen beim Flugplatz Buochs.", latitude: 46.972664, longitude: 8.405404, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 15.25, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993911.0)),
        BusinessLocationMock(id: 42, name: "Brunnen, Muota", shortName: "BRU", description: "Die Temperatur der Muota, gemessen bei Brunnen.", latitude: 47.000861, longitude: 8.599145, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 17.93, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993911.0)),
        BusinessLocationMock(id: 44, name: "Landquart, Felsenbach", shortName: "LAN", description: "Die Temperatur des Felsenbachs, gemessen in der Chlus.", latitude: 46.974576, longitude: 9.612473, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 17.75, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993911.0)),
        BusinessLocationMock(id: 46, name: "S-chanf, Inn", shortName: "S-C", description: "Die Temperatur des Inns, gemessen in S-chanf.", latitude: 46.615707, longitude: 9.99487, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 13.59, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993911.0)),
        BusinessLocationMock(id: 47, name: "Vulpera, Inn", shortName: "VUL", description: "Die Temperatur des Inns, gemessen bei Vulpera kurz vor Scuol.", latitude: 46.789006, longitude: 10.278915, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 15.4, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993911.0)),
        BusinessLocationMock(id: 48, name: "Müstair, Rom", shortName: "MUS", description: "Die Temperatur des Rombachs, gemessen in Müstair.", latitude: 46.629663, longitude: 10.453207, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 13.23, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993911.0)),
        BusinessLocationMock(id: 49, name: "Pontresina, Rosegbach", shortName: "PON", description: "Die Temperatur des Rosegbachs, gemessen kurz vor Pontresina.", latitude: 46.489901, longitude: 9.897906, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 11.57, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993911.0)),
        BusinessLocationMock(id: 50, name: "Cugnasco, Ticino", shortName: "CUG", description: "Die Temperatur des Ticino, gemessen zwischen Cugnasco und Quartino.", latitude: 46.163568, longitude: 8.909943, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 21.29, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 51, name: "Lavertezzo, Riale di Pincascia", shortName: "LAV", description: "Die Temperatur der Riale di Pincascia, gemessen im Verzascatal bei Lavertezzo.", latitude: 46.258314, longitude: 8.840149, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 19.69, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 53, name: "Visp, Vispa", shortName: "VIS", description: "Die Temperatur der Vispa, gemessen kurz vor Visp.", latitude: 46.283697, longitude: 7.880381, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 8.96, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 54, name: "Adelboden, Allenbach", shortName: "ADE", description: "Die Temperatur des Allenbachs, gemessen in Adelboden.", latitude: 46.485917, longitude: 7.551805, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 14.6, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 55, name: "Vouvry, Rhone", shortName: "VOU", description: "Die Temperatur der Rhone, gemessen bei Vouvry.", latitude: 46.349483, longitude: 6.888185, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 10.68, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 41, name: "Bennau, Alp", shortName: "BEN", description: "Die Temperatur der Alp, gemessen bei Bennau nahe Einsiedeln.", latitude: 47.150814, longitude: 8.739312, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 24.86, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993910.0)),
        BusinessLocationMock(id: 45, name: "Ilanz, Vorderrhein", shortName: "ILA", description: "Die Temperatur des Vorderrheins, gemessen in Ilanz.", latitude: 46.776022, longitude: 9.206217, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 18.12, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993911.0)),
        BusinessLocationMock(id: 52, name: "Ponte Tresa, Tresa", shortName: "PON", description: "Die Temperatur der Tresa, gemessen in Ponte Tresa.", latitude: 45.971892, longitude: 8.852307, creationDate: Date(timeIntervalSinceReferenceDate: 775517830.0), sponsorID: 6, lastTemperature: 28.59, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 56, name: "Boncourt, Allaine", shortName: "BON", description: "Wassertemperatur der Allaine, gemessen bei Boncourt.", latitude: 47.500821, longitude: 7.012017, creationDate: Date(timeIntervalSinceReferenceDate: 789403239.0), sponsorID: 6, lastTemperature: 22.85, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 57, name: "Allaman, Aubonne", shortName: "ALL", description: "Wassertemperatur der Aubonne, gemessen bei Allaman.", latitude: 46.473189, longitude: 6.406589, creationDate: Date(timeIntervalSinceReferenceDate: 789403452.0), sponsorID: 6, lastTemperature: 19.15, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 58, name: "Davos, Dischmabach", shortName: "DIS", description: "Wassertemperatur des Dischmabach, gemessen in Davos.", latitude: 46.77539, longitude: 9.877377, creationDate: Date(timeIntervalSinceReferenceDate: 789403550.0), sponsorID: 6, lastTemperature: 13.134, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 59, name: "Olten, Dünnern", shortName: "OLT", description: "Wassertemperatur der Dünnern, gemessen bei Olten.", latitude: 47.350186, longitude: 7.892929, creationDate: Date(timeIntervalSinceReferenceDate: 789403627.0), sponsorID: 6, lastTemperature: 25.31, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 60, name: "Goldach, Goldach", shortName: "GOL", description: "Wassertemperatur der Goldach, gemessen bei Goldach.", latitude: 47.486582, longitude: 9.470837, creationDate: Date(timeIntervalSinceReferenceDate: 789403707.0), sponsorID: 6, lastTemperature: 25.16, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 61, name: "Einsiedeln, Grossbach", shortName: "EIN", description: "Wassertemperatur des Grossbach, gemessen bei Einsiedeln.", latitude: 47.106322, longitude: 8.765613, creationDate: Date(timeIntervalSinceReferenceDate: 789403790.0), sponsorID: 6, lastTemperature: 22.08, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 62, name: "Isenthal, Grosstalbach", shortName: "GTB", description: "Wassertemperatur des Grosstalbach, gemessen bei Isenthal.", latitude: 46.910041, longitude: 8.561149, creationDate: Date(timeIntervalSinceReferenceDate: 789403852.0), sponsorID: 6, lastTemperature: 13.59, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 63, name: "Belp, Gürbe", shortName: "BEL", description: "Wassertemperatur der Gürbe, gemessen bei Belp.", latitude: 46.885144, longitude: 7.50199, creationDate: Date(timeIntervalSinceReferenceDate: 789403904.0), sponsorID: 6, lastTemperature: 24.97, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993912.0)),
        BusinessLocationMock(id: 65, name: "Ruggell, Liechtensteiner Binnenkanal", shortName: "RUG", description: "Wassertemperatur des Liechtensteiner Binnenkanal, gemessen bei Ruggell.", latitude: 47.243858, longitude: 9.520449, creationDate: Date(timeIntervalSinceReferenceDate: 789404029.0), sponsorID: 6, lastTemperature: 16.72, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 66, name: "Blatten, Lonza", shortName: "BLA", description: "Wassertemperatur der Lonza, gemessen bei Blatten.", latitude: 46.419014, longitude: 7.817582, creationDate: Date(timeIntervalSinceReferenceDate: 789404093.0), sponsorID: 6, lastTemperature: 5.76, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 789406028.0), isActive: false),
        BusinessLocationMock(id: 67, name: "Blatten bei Naters, Massa", shortName: "BLA", description: "Wassertemperatur der Massa, gemessen bei Blatten bei Naters.", latitude: 46.385544, longitude: 8.006569, creationDate: Date(timeIntervalSinceReferenceDate: 789404167.0), sponsorID: 6, lastTemperature: 1.4, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 68, name: "Yvonand, Menthue", shortName: "YVO", description: "Wassertemperatur der Menthue, gemessen bei Yvonand.", latitude: 46.776685, longitude: 6.724344, creationDate: Date(timeIntervalSinceReferenceDate: 789404221.0), sponsorID: 6, lastTemperature: 22.63, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 69, name: "Frauenfeld, Murg", shortName: "MUR", description: "Wassertemperatur der Murg, gemessen bei Frauenfeld.", latitude: 47.568573, longitude: 8.894379, creationDate: Date(timeIntervalSinceReferenceDate: 789404288.0), sponsorID: 6, lastTemperature: 22.99, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 70, name: "Wängi, Murg", shortName: "WAN", description: "Wassertemperatur der Murg, gemessen bei Wängi.", latitude: 47.496192, longitude: 8.95304, creationDate: Date(timeIntervalSinceReferenceDate: 789404342.0), sponsorID: 6, lastTemperature: 21.66, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 71, name: "Mogelsberg, Necker", shortName: "MOG", description: "Wassertemperatur der Necker, gemessen bei Mogelsberg.", latitude: 47.364169, longitude: 9.121274, creationDate: Date(timeIntervalSinceReferenceDate: 789404400.0), sponsorID: 6, lastTemperature: 23.76, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 72, name: "La Rösa, Poschiavino", shortName: "LRÖ", description: "Wassertemperatur des Poschiavino, gemessen bei La Rösa.", latitude: 46.398977, longitude: 10.06703, creationDate: Date(timeIntervalSinceReferenceDate: 789404464.0), sponsorID: 6, lastTemperature: 12.27, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 73, name: "Mellingen, Reuss", shortName: "MEL", description: "Wassertemperatur der Reuss, gemessen bei Mellingen.", latitude: 47.421025, longitude: 8.271403, creationDate: Date(timeIntervalSinceReferenceDate: 789404512.0), sponsorID: 6, lastTemperature: 25.41, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 74, name: "Diepoldsau, Rhein", shortName: "DIE", description: "Wassertemperatur des Rheins, gemessen bei Diepoldsau.", latitude: 47.382953, longitude: 9.641629, creationDate: Date(timeIntervalSinceReferenceDate: 789404571.0), sponsorID: 6, lastTemperature: 18.66, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 75, name: "Neuhausen, Rhein", shortName: "NEU", description: "Wassertemperatur des Rheins, gemessen bei Neuhausen.", latitude: 47.682463, longitude: 8.625925, creationDate: Date(timeIntervalSinceReferenceDate: 789404656.0), sponsorID: 6, lastTemperature: 25.2, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 76, name: "Laufenburg, Rhein", shortName: "LAU", description: "Wassertemperatur des Rheins, gemessen bei Laufenburg.", latitude: 47.556319, longitude: 8.050548, creationDate: Date(timeIntervalSinceReferenceDate: 789404711.0), sponsorID: 6, lastTemperature: 25.02, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 77, name: "Rheinau, Rhein", shortName: "RHE", description: "Wassertemperatur des Rheins, gemessen bei Rheinau.", latitude: 47.639163, longitude: 8.602079, creationDate: Date(timeIntervalSinceReferenceDate: 789404769.0), sponsorID: 6, lastTemperature: 25.38, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
        BusinessLocationMock(id: 78, name: "Chancy, Rhone", shortName: "CHA", description: "Wassertemperatur der Rhone, gemessen bei Chancy.", latitude: 46.152908, longitude: 5.970849, creationDate: Date(timeIntervalSinceReferenceDate: 789404813.0), sponsorID: 6, lastTemperature: 20.81, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993914.0)),
        BusinessLocationMock(id: 79, name: "Genf, Rhone", shortName: "GEN", description: "Wassertemperatur der Rhone, gemessen bei Genf.", latitude: 46.204665, longitude: 6.141626, creationDate: Date(timeIntervalSinceReferenceDate: 789404876.0), sponsorID: 6, lastTemperature: 23.34, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993914.0)),
        BusinessLocationMock(id: 80, name: "Roveredo, Riale di Roggiasca", shortName: "ROV", description: "Wassertemperatur des Riale di Roggiasca, gemessen bei Roveredo.", latitude: 46.201664, longitude: 9.169141, creationDate: Date(timeIntervalSinceReferenceDate: 789404954.0), sponsorID: 6, lastTemperature: 15.39, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993914.0)),
        BusinessLocationMock(id: 81, name: "Mosnang, Rietholzbach", shortName: "MOS", description: "Wassertemperatur des Rietholzbach, gemessen bei Mosnang.", latitude: 47.376035, longitude: 9.01215, creationDate: Date(timeIntervalSinceReferenceDate: 789405050.0), sponsorID: 6, lastTemperature: 17.02, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993914.0)),
        BusinessLocationMock(id: 82, name: "Gümmenen, Saane", shortName: "GÜM", description: "Wassertemperatur der Saane, gemessen bei Gümmenen.", latitude: 46.943588, longitude: 7.243128, creationDate: Date(timeIntervalSinceReferenceDate: 789405105.0), sponsorID: 6, lastTemperature: 22.36, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805992096.0)),
        BusinessLocationMock(id: 83, name: "Neuenkirch, Sellesbodenbach", shortName: "NKI", description: "Wassertemperatur des Sellesbodenbach, gemessen bei Neuenkirch.", latitude: 47.112728, longitude: 8.210114, creationDate: Date(timeIntervalSinceReferenceDate: 789405156.0), sponsorID: 6, lastTemperature: 21.74, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805992096.0)),
        BusinessLocationMock(id: 84, name: "Appenzell, Sitter", shortName: "APZ", description: "Wassertemperatur der Sitter, gemessen bei Appenzell.", latitude: 47.331946, longitude: 9.410426, creationDate: Date(timeIntervalSinceReferenceDate: 789405207.0), sponsorID: 6, lastTemperature: 22.97, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805992096.0)),
        BusinessLocationMock(id: 85, name: "Wasen, Sperbelgraben", shortName: "WAS", description: "Wassertemperatur des Sperbelgraben, gemessen bei Wasen.", latitude: 47.015764, longitude: 7.842783, creationDate: Date(timeIntervalSinceReferenceDate: 789405281.0), sponsorID: 6, lastTemperature: 15.19, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993005.0)),
        BusinessLocationMock(id: 86, name: "Sonceboz, Suze", shortName: "SON", description: "Wassertemperatur der Suze, gemessen bei Sonceboz.", latitude: 47.196753, longitude: 7.172428, creationDate: Date(timeIntervalSinceReferenceDate: 789405322.0), sponsorID: 6, lastTemperature: 14.21, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993005.0)),
        BusinessLocationMock(id: 87, name: "Andelfingen, Thur", shortName: "AND", description: "Wassertemperatur der Thur, gemessen bei Andelfingen.", latitude: 47.596465, longitude: 8.681978, creationDate: Date(timeIntervalSinceReferenceDate: 789405369.0), sponsorID: 6, lastTemperature: 24.09, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993005.0)),
        BusinessLocationMock(id: 88, name: "Halden, Thur", shortName: "HAL", description: "Wassertemperatur der Thur, gemessen bei Halden.", latitude: 47.50555, longitude: 9.21125, creationDate: Date(timeIntervalSinceReferenceDate: 789405411.0), sponsorID: 6, lastTemperature: 25.77, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993005.0)),
        BusinessLocationMock(id: 89, name: "Ecublens, Venoge", shortName: "ECU", description: "Wassertemperatur der Venoge, gemessen bei Ecublens.", latitude: 46.535352, longitude: 6.552428, creationDate: Date(timeIntervalSinceReferenceDate: 789405457.0), sponsorID: 6, lastTemperature: 22.05, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993005.0)),
        BusinessLocationMock(id: 90, name: "Ittigen, Worble", shortName: "ITT", description: "Wassertemperatur der Worble, gemessen bei Ittigen.", latitude: 46.973307, longitude: 7.478102, creationDate: Date(timeIntervalSinceReferenceDate: 789405507.0), sponsorID: 6, lastTemperature: 18.62, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993006.0)),
        BusinessLocationMock(id: 91, name: "St. Margrethen, Rhein", shortName: "STM", description: "Wassertemperatur des Rheins, gemessen bei St. Margrethen.", latitude: 47.449697, longitude: 9.655671, creationDate: Date(timeIntervalSinceReferenceDate: 789405654.0), sponsorID: 6, lastTemperature: 18.01, lastTemperatureDate: Date(timeIntervalSinceReferenceDate: 805993913.0)),
    ]

    /// The location opened for the detail screenshot — "Bern, Aare" (id 16), the one fixture with a
    /// populated highest / lowest / average summary.
    static var screenshotDetail: BusinessLocationMock {
        screenshotLocations.first { $0.id == 16 }!
    }

    /// Location IDs pre-marked as favorites for the screenshots. Screenshot mode seeds these into the
    /// `"favorites"` `UserDefaults` key (a JSON-encoded `[Int]`, see `Array: RawRepresentable`).
    ///
    /// Kempraten (6), Zürich Sihl (15), Bern Aare (16), Luzern Reuss (39), Ponte Tresa (52),
    /// Genf Rhone (79).
    static let screenshotFavoriteIDs: [Int] = [6, 15, 16, 39, 52, 79]
}
