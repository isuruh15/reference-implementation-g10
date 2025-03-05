// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.
//
//
// AUTO-GENERATED FILE.
//
// This file is auto-generated by Ballerina.
// Developers are allowed to modify this file as per the requirement.

import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhirr4;
import ballerinax/health.fhir.r4.parser as fhirParser;
import ballerinax/health.fhir.r4.uscore311;

# Generic type to wrap all implemented profiles.
# Add required profile types here.
# public type Goal r4:Goal|<other_Goal_Profile>;
public type Goal uscore311:USCoreGoalProfile;

# initialize source system endpoint here

# A service representing a network-accessible API
# bound to port `9090`.
service / on new fhirr4:Listener(9090, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get fhir/r4/Goal/[string id](r4:FHIRContext fhirContext) returns Goal|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if (fhirResource.resourceType == "Goal" && fhirResource.id == id) {
                    Goal goal = check fhirParser:parse(fhirResource, uscore311:USCoreGoalProfile).ensureType();
                    return goal.clone();
                }
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get fhir/r4/Goal/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns Goal|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get fhir/r4/Goal(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {
        return filterData(fhirContext);
    }

    // Create a new resource.
    isolated resource function post fhir/r4/Goal(r4:FHIRContext fhirContext, Goal procedure) returns Goal|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put fhir/r4/Goal/[string id](r4:FHIRContext fhirContext, Goal goal) returns Goal|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch fhir/r4/Goal/[string id](r4:FHIRContext fhirContext, json patch) returns Goal|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete fhir/r4/Goal/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get fhir/r4/Goal/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get fhir/r4/Goal/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // post search request
    isolated resource function post fhir/r4/Goal/_search(r4:FHIRContext fhirContext) returns r4:FHIRError|http:Response {
        r4:Bundle|error result = filterData(fhirContext);
        if result is r4:Bundle {
            http:Response response = new;
            response.statusCode = http:STATUS_OK;
            response.setPayload(result.clone().toJson());
            return response;
        } else {
            return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
        }
    }
}

configurable string baseUrl = "localhost:9091/fhir/r4";
final http:Client apiClient = check new (baseUrl);

isolated function addRevInclude(string revInclude, r4:Bundle bundle, int entryCount, string apiName) returns r4:Bundle|error {

    if revInclude == "" {
        return bundle;
    }
    string[] ids = check buildSearchIds(bundle, apiName);
    if ids.length() == 0 {
        return bundle;
    }

    int count = entryCount;
    http:Response response = check apiClient->/Provenance(target = string:'join(",", ...ids));
    if (response.statusCode == 200) {
        json fhirResource = check response.getJsonPayload();
        json[] entries = check fhirResource.entry.ensureType();
        foreach json entry in entries {
            map<json> entryResource = check entry.'resource.ensureType();
            string entryUrl = check entry.fullUrl.ensureType();
            r4:BundleEntry bundleEntry = {fullUrl: entryUrl, 'resource: entryResource};
            bundle.entry[count] = bundleEntry;
            count += 1;
        }
    }
    return bundle;
}

isolated function buildSearchIds(r4:Bundle bundle, string apiName) returns string[]|error {
    r4:BundleEntry[] entries = check bundle.entry.ensureType();
    string[] searchIds = [];
    foreach r4:BundleEntry entry in entries {
        var entryResource = entry?.'resource;
        if (entryResource == ()) {
            continue;
        }
        map<json> entryResourceJson = check entryResource.ensureType();
        string id = check entryResourceJson.id.ensureType();
        string resourceType = check entryResourceJson.resourceType.ensureType();
        if (resourceType == apiName) {
            searchIds.push(resourceType + "/" + id);
        }
    }
    return searchIds;
}

isolated function filterData(r4:FHIRContext fhirContext) returns r4:FHIRError|r4:Bundle|error|error {
    r4:StringSearchParameter[] idParam = check fhirContext.getStringSearchParameter("_id") ?: [];
    string[] ids = [];
    foreach r4:StringSearchParameter item in idParam {
        string id = check item.value.ensureType();
        ids.push(id);
    }
    r4:TokenSearchParameter[] statusParam = check fhirContext.getTokenSearchParameter("status") ?: [];
    string[] statuses = [];
    foreach r4:TokenSearchParameter item in statusParam {
        string id = check item.code.ensureType();
        statuses.push(id);
    }
    r4:TokenSearchParameter[] categoryParam = check fhirContext.getTokenSearchParameter("category") ?: [];
    string[] categories = [];
    foreach r4:TokenSearchParameter item in categoryParam {
        string id = check item.code.ensureType();
        categories.push(id);
    }
    r4:ReferenceSearchParameter[] patientParam = check fhirContext.getReferenceSearchParameter("patient") ?: [];
    string[] patients = [];
    foreach r4:ReferenceSearchParameter item in patientParam {
        string id = check item.id.ensureType();
        patients.push("Patient/" + id);
    }
    r4:TokenSearchParameter[] revIncludeParam = check fhirContext.getTokenSearchParameter("_revinclude") ?: [];
    string revInclude = revIncludeParam != [] ? check revIncludeParam[0].code.ensureType() : "";
    lock {

        r4:Bundle bundle = {identifier: {system: ""}, 'type: "searchset", entry: []};
        r4:BundleEntry bundleEntry = {};
        int count = 0;
        // filter by id
        json[] resultSet = data;
        if (ids.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("id") {
                    string id = check fhirResource.id.ensureType();
                    if (fhirResource.resourceType == "Goal" && ids.indexOf(id) > -1) {
                        resultSet.push(fhirResource);
                        continue;
                    }
                }
            }
        }

        resultSet = resultSet.length() > 0 ? resultSet : data;
        // filter by patient
        json[] patientFilteredData = [];
        if (patients.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("subject") {
                    map<json> patient = check fhirResource.subject.ensureType();
                    if patient.hasKey("reference") {
                        string patientRef = check patient.reference.ensureType();
                        if (patients.indexOf(patientRef) > -1) {
                            patientFilteredData.push(fhirResource);
                            continue;
                        }
                    }
                }
            }
            resultSet = patientFilteredData;
        }

        // filter by category
        json[] categoryFilteredData = [];
        if (categories.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("category") {
                    json[] categoryResources = check fhirResource.category.ensureType();
                    foreach json category in categoryResources {
                        map<json> categoryResource = check category.ensureType();
                        if categoryResource.hasKey("coding") {
                            json[] coding = check categoryResource.coding.ensureType();
                            foreach json codingItem in coding {
                                map<json> codingResource = check codingItem.ensureType();
                                if codingResource.hasKey("code") {
                                    string code = check codingResource.code.ensureType();
                                    if (categories.indexOf(code) > -1) {
                                        categoryFilteredData.push(fhirResource);
                                        continue;
                                    }
                                }

                            }
                        }
                    }
                }
            }
            resultSet = categoryFilteredData;
        }

        // filter by status
        json[] statusFilteredData = [];
        if (statuses.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("status") {
                    string status = check fhirResource.status.ensureType();

                    if (statuses.indexOf(status) > -1) {
                        statusFilteredData.push(fhirResource);
                        continue;
                    }

                }
            }
            resultSet = statusFilteredData;
        }

        foreach json item in resultSet {
            bundleEntry = {fullUrl: "", 'resource: item};
            bundle.entry[count] = bundleEntry;
            count += 1;
        }

        if bundle.entry != [] {
            return addRevInclude(revInclude, bundle, count, "Goal").clone();
        }
        return bundle.clone();
    }

}

isolated json[] data = [
    {
        "resourceType": "Goal",
        "id": "patient-1-weight-loss-goal",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal"
            ]
        },
        "lifecycleStatus": "active",
        "achievementStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/goal-achievement",
                    "code": "improving",
                    "display": "Improving"
                }
            ],
            "text": "Improving"
        },
        "category": [
            {
                "coding": [
                    {
                        "system": "http://snomed.info/sct",
                        "code": "408907002",
                        "display": "Weight loss"
                    }
                ],
                "text": "Weight loss"
            }
        ],
        "description": {
            "text": "Lose 10 pounds over the next 3 months"
        },
        "subject": {
            "reference": "Patient/1",
            "display": "John Doe"
        },
        "startDate": "2024-02-01",
        "target": [
            {
                "measure": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "29463-7",
                            "display": "Body weight"
                        }
                    ],
                    "text": "Body weight"
                },
                "detailQuantity": {
                    "value": 75,
                    "unit": "kg",
                    "system": "http://unitsofmeasure.org",
                    "code": "kg"
                },
                "dueDate": "2024-05-01"
            }
        ]
    },
    {
        "resourceType": "Goal",
        "id": "patient-2-bp-goal",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal"
            ]
        },
        "lifecycleStatus": "active",
        "achievementStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/goal-achievement",
                    "code": "in-progress",
                    "display": "In Progress"
                }
            ],
            "text": "In Progress"
        },
        "category": [
            {
                "coding": [
                    {
                        "system": "http://snomed.info/sct",
                        "code": "75367002",
                        "display": "Control blood pressure"
                    }
                ],
                "text": "Control blood pressure"
            }
        ],
        "description": {
            "text": "Maintain blood pressure below 130/80 mmHg"
        },
        "subject": {
            "reference": "Patient/2",
            "display": "Jane Smith"
        },
        "startDate": "2024-01-10",
        "target": [
            {
                "measure": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "85354-9",
                            "display": "Blood pressure panel"
                        }
                    ],
                    "text": "Blood pressure"
                },
                "detailQuantity": {
                    "value": 130,
                    "unit": "mmHg",
                    "system": "http://unitsofmeasure.org",
                    "code": "mm[Hg]"
                },
                "dueDate": "2024-06-10"
            }
        ]
    },
    {
        "resourceType": "Goal",
        "id": "patient-4-activity-goal",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal"
            ]
        },
        "lifecycleStatus": "active",
        "achievementStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/goal-achievement",
                    "code": "achievable",
                    "display": "Achievable"
                }
            ],
            "text": "Achievable"
        },
        "category": [
            {
                "coding": [
                    {
                        "system": "http://snomed.info/sct",
                        "code": "226105000",
                        "display": "Increase physical activity"
                    }
                ],
                "text": "Increase physical activity"
            }
        ],
        "description": {
            "text": "Exercise at least 30 minutes per day, 5 days per week"
        },
        "subject": {
            "reference": "Patient/4",
            "display": "Michael Brown"
        },
        "startDate": "2024-03-01",
        "target": [
            {
                "measure": {
                    "coding": [
                        {
                            "system": "http://loinc.org",
                            "code": "41950-7",
                            "display": "Physical activity"
                        }
                    ],
                    "text": "Physical activity"
                },
                "detailRange": {
                    "low": {
                        "value": 30,
                        "unit": "minutes",
                        "system": "http://unitsofmeasure.org",
                        "code": "min"
                    },
                    "high": {
                        "value": 60,
                        "unit": "minutes",
                        "system": "http://unitsofmeasure.org",
                        "code": "min"
                    }
                },
                "dueDate": "2024-06-01"
            }
        ]
    }

];
