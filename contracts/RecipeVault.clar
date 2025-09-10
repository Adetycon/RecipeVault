;; RecipeVault: Decentralized Culinary Recipe Sharing Platform
;; Version: 1.0.0

(define-constant ERR-UNAUTHORIZED-ACCESS (err u1))
(define-constant ERR-RECIPE-NOT-EXISTS (err u2))
(define-constant ERR-ALREADY-ACTIVE (err u3))
(define-constant ERR-INVALID-STATE (err u4))
(define-constant ERR-INVALID-PREP-TIME (err u5))
(define-constant ERR-INVALID-CUISINE-TYPE (err u6))
(define-constant ERR-INVALID-DIFFICULTY-LEVEL (err u7))
(define-constant ERR-INVALID-RECIPE-NAME (err u8))
(define-constant ERR-INVALID-INSTRUCTIONS (err u9))

(define-constant MIN-PREP-TIME u10)

(define-data-var next-recipe-id uint u1)

(define-map culinary-collection
    uint
    {
        chef: principal,
        recipe-name: (string-utf8 50),
        instructions: (string-utf8 200),
        cuisine-type: (string-utf8 15),
        difficulty-level: (string-utf8 10),
        availability-status: (string-utf8 15),
        prep-time-minutes: uint
    }
)

(define-private (validate-cuisine-type (cuisine-type (string-utf8 15)))
    (or 
        (is-eq cuisine-type u"Italian")
        (is-eq cuisine-type u"Asian")
        (is-eq cuisine-type u"Mexican")
        (is-eq cuisine-type u"French")
        (is-eq cuisine-type u"Indian")
        (is-eq cuisine-type u"American")
    )
)

(define-private (validate-difficulty-level (difficulty-level (string-utf8 10)))
    (or 
        (is-eq difficulty-level u"Beginner")
        (is-eq difficulty-level u"Easy")
        (is-eq difficulty-level u"Medium")
        (is-eq difficulty-level u"Hard")
        (is-eq difficulty-level u"Expert")
    )
)

(define-private (validate-text-content (text (string-utf8 200)) (min-length uint) (max-length uint))
    (let 
        (
            (text-length (len text))
        )
        (and 
            (>= text-length min-length)
            (<= text-length max-length)
        )
    )
)

(define-public (share-recipe 
    (recipe-name (string-utf8 50))
    (instructions (string-utf8 200))
    (cuisine-type (string-utf8 15))
    (difficulty-level (string-utf8 10))
    (prep-time-minutes uint)
)
    (let
        (
            (recipe-id (var-get next-recipe-id))
        )
        (asserts! (validate-text-content recipe-name u3 u50) ERR-INVALID-RECIPE-NAME)
        (asserts! (validate-text-content instructions u10 u200) ERR-INVALID-INSTRUCTIONS)
        (asserts! (>= prep-time-minutes MIN-PREP-TIME) ERR-INVALID-PREP-TIME)
        (asserts! (validate-cuisine-type cuisine-type) ERR-INVALID-CUISINE-TYPE)
        (asserts! (validate-difficulty-level difficulty-level) ERR-INVALID-DIFFICULTY-LEVEL)
        
        (map-set culinary-collection recipe-id {
            chef: tx-sender,
            recipe-name: recipe-name,
            instructions: instructions,
            cuisine-type: cuisine-type,
            difficulty-level: difficulty-level,
            availability-status: u"active",
            prep-time-minutes: prep-time-minutes
        })
        (var-set next-recipe-id (+ recipe-id u1))
        (ok recipe-id)
    )
)

(define-public (remove-recipe (recipe-id uint))
    (let
        (
            (recipe (unwrap! (map-get? culinary-collection recipe-id) ERR-RECIPE-NOT-EXISTS))
        )
        (asserts! (is-eq tx-sender (get chef recipe)) ERR-UNAUTHORIZED-ACCESS)
        (asserts! (is-eq (get availability-status recipe) u"active") ERR-INVALID-STATE)
        (ok (map-set culinary-collection recipe-id (merge recipe { availability-status: u"removed" })))
    )
)

(define-read-only (get-recipe (recipe-id uint))
    (ok (map-get? culinary-collection recipe-id))
)

(define-read-only (get-chef (recipe-id uint))
    (ok (get chef (unwrap! (map-get? culinary-collection recipe-id) ERR-RECIPE-NOT-EXISTS)))
)
