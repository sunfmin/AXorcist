// CriteriaMatchingHelpers.swift - Helper functions for criteria matching

import Foundation

// MARK: - Criteria Matching Helper

@MainActor
public func elementMatchesAllCriteria(
    element: Element,
    criteria: [Criterion],
    matchType: JSONPathHintComponent.MatchType = .exact) -> Bool
{
    for criterion in criteria {
        let effectiveMatchType = criterion.matchType ?? matchType
        // Pass nil for elementDescriptionForLog to avoid expensive briefDescription
        // calls on every element during large tree traversals (e.g. Safari web DOM).
        if !matchSingleCriterion(
            element: element,
            key: criterion.attribute,
            expectedValue: criterion.value,
            matchType: effectiveMatchType,
            elementDescriptionForLog: nil)
        {
            return false
        }
    }
    return true
}

@MainActor
public func elementMatchesAnyCriterion(
    element: Element,
    criteria: [Criterion],
    matchType: JSONPathHintComponent.MatchType = .exact) -> Bool
{
    if criteria.isEmpty {
        return false
    }
    for criterion in criteria {
        let effectiveMatchType = criterion.matchType ?? matchType
        if matchSingleCriterion(
            element: element,
            key: criterion.attribute,
            expectedValue: criterion.value,
            matchType: effectiveMatchType,
            elementDescriptionForLog: nil)
        {
            return true
        }
    }
    return false
}

@MainActor
public func elementMatchesCriteria(
    _ element: Element,
    criteria: [String: String],
    matchType: JSONPathHintComponent.MatchType = .exact) -> Bool
{
    let criterionArray = criteria.map { key, value in
        Criterion(attribute: key, value: value, matchType: nil)
    }
    return elementMatchesAllCriteria(element: element, criteria: criterionArray, matchType: matchType)
}
