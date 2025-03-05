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
# public type DocumentReference r4:DocumentReference|<other_DocumentReference_Profile>;
public type DocumentReference uscore311:USCoreDocumentReferenceProfile;

# initialize source system endpoint here

# A service representing a network-accessible API
# bound to port `9090`.
service / on new fhirr4:Listener(9090, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get fhir/r4/DocumentReference/[string id](r4:FHIRContext fhirContext) returns DocumentReference|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if (fhirResource.resourceType == "DocumentReference" && fhirResource.id == id) {
                    DocumentReference documentReference = check fhirParser:parse(fhirResource, uscore311:USCoreDocumentReferenceProfile).ensureType();
                    return documentReference.clone();
                }
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get fhir/r4/DocumentReference/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns DocumentReference|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get fhir/r4/DocumentReference(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {
        return filterData(fhirContext);
    }

    // Create a new resource.
    isolated resource function post fhir/r4/DocumentReference(r4:FHIRContext fhirContext, DocumentReference procedure) returns DocumentReference|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put fhir/r4/DocumentReference/[string id](r4:FHIRContext fhirContext, DocumentReference documentreference) returns DocumentReference|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch fhir/r4/DocumentReference/[string id](r4:FHIRContext fhirContext, json patch) returns DocumentReference|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete fhir/r4/DocumentReference/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get fhir/r4/DocumentReference/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get fhir/r4/DocumentReference/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // post search request
    isolated resource function post fhir/r4/DocumentReference/_search(r4:FHIRContext fhirContext) returns r4:FHIRError|http:Response {
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
        json[] idFilteredData = [];
        if (ids.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("id") {
                    string id = check fhirResource.id.ensureType();
                    if (fhirResource.resourceType == "DocumentReference" && ids.indexOf(id) > -1) {
                        idFilteredData.push(fhirResource);
                        continue;
                    }
                }
            }
            resultSet = idFilteredData;
        }

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
            return addRevInclude(revInclude, bundle, count, "DocumentReference").clone();
        }
        return bundle.clone();
    }

}

isolated json[] data = [
    {
        "resourceType": "DocumentReference",
        "id": "patient-1-lab-doc",
        "identifier": [
            {
                "system": "urn:ietf:rfc:3986",
                "value": "urn:uuid:acc9d16d-da9b-9dc9-fbb4-9e6f950b11e6"
            }
        ],
        "author": [
            {
                "reference": "Practitioner/111",
                "display": "Dr. Melvin857 Torp761"
            }
        ],
        "context": {
            "encounter": [
                {
                    "reference": "Encounter/a904bd7f-257e-4738-867d-ff31c4314b87"
                }
            ],
            "period": {
                "start": "1940-09-06T01:11:45-04:00",
                "end": "1940-09-06T01:26:45-04:00"
            }
        },
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference"
            ]
        },
        "status": "current",
        "docStatus": "final",
        "type": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "100449-8",
                    "display": "Progress note"
                }
            ],
            "text": "Complete Blood Count (CBC) Panel"
        },
        "category": [
            {
                "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "26436-6",
                        "display": "Laboratory"
                    }
                ],
                "text": "Laboratory"
            }
        ],
        "subject": {
            "reference": "Patient/1",
            "display": "John Doe"
        },
        "date": "2023-01-15T10:30:00.000Z",
        "content": [
            {
                "attachment": {
                    "contentType": "text/plain",
                    "data": "CjE5NDAtMDktMDYKCiMg",
                    "title": "Complete Blood Count (CBC) Report",
                    "creation": "2023-01-15T10:30:00.000Z"
                },
                "format": {
                    "system": "http://ihe.net/fhir/ValueSet/IHE.FormatCode.codesystem",
                    "code": "urn:ihe:iti:xds:2017:mimeTypeSufficient",
                    "display": "mimeType Sufficient"
                }
            }
        ]
    },
    {
        "resourceType": "DocumentReference",
        "id": "patient-2-xray-doc",
        "identifier": [
            {
                "system": "urn:ietf:rfc:3986",
                "value": "urn:uuid:acc9d16d-da9b-9dc9-fbb4-9e6f950b11e6"
            }
        ],
        "author": [
            {
                "reference": "Practitioner/333",
                "display": "Dr. Melvin857 Torp761"
            }
        ],
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference"
            ]
        },
        "status": "current",
        "docStatus": "final",
        "type": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "30746-2",
                    "display": "Portable XR Chest Views"
                }
            ],
            "text": "Portable XR Chest Views"
        },
        "category": [
            {
                "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "LP29684-5",
                        "display": "Radiology"
                    }
                ],
                "text": "Radiology"
            }
        ],
        "subject": {
            "reference": "Patient/2",
            "display": "Jane Smith"
        },
        "date": "2023-07-20T15:45:00.000Z",
        "content": [
            {
                "attachment": {
                    "contentType": "text/plain",
                    "data": "CjE5NDAtMDktMDYKCiMg",
                    "title": "Chest X-Ray Report",
                    "creation": "2023-07-20T15:45:00.000Z"
                },
                "format": {
                    "system": "http://ihe.net/fhir/ValueSet/IHE.FormatCode.codesystem",
                    "code": "urn:ihe:iti:xds:2017:mimeTypeSufficient",
                    "display": "mimeType Sufficient"
                }
            }
        ],
        "context": {
            "encounter": [
                {
                    "reference": "Encounter/patient-2-xray-encounter"
                }
            ],
            "period": {
                "start": "2023-07-20T15:30:00.000Z",
                "end": "2023-07-20T16:00:00.000Z"
            }
        }
    },
    {
        "resourceType": "DocumentReference",
        "id": "patient-4-mri-doc",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference"
            ]
        },
        "status": "current",
        "docStatus": "final",
        "type": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "11328-7",
                    "display": "MRI Brain"
                }
            ],
            "text": "MRI Brain"
        },
        "category": [
            {
                "coding": [
                    {
                        "system": "http://loinc.org",
                        "code": "LP29684-5",
                        "display": "Radiology"
                    }
                ],
                "text": "Radiology"
            }
        ],
        "subject": {
            "reference": "Patient/4",
            "display": "Michael Brown"
        },
        "date": "2023-09-10T08:15:00.000Z",
        "content": [
            {
                "attachment": {
                    "contentType": "text/plain",
                    "data": "CjE5NDAtMDktMDYKCiMg",
                    "title": "Brain MRI Report",
                    "creation": "2023-09-10T08:15:00.000Z"
                },
                "format": {
                    "system": "http://ihe.net/fhir/ValueSet/IHE.FormatCode.codesystem",
                    "code": "urn:ihe:iti:xds:2017:mimeTypeSufficient",
                    "display": "mimeType Sufficient"
                }
            }
        ],
        "context": {
            "encounter": [
                {
                    "reference": "Encounter/patient-4-mri-encounter"
                }
            ],
            "period": {
                "start": "2023-09-10T08:00:00.000Z",
                "end": "2023-09-10T08:30:00.000Z"
            }
        }
    }

];
