;; NFT-based Gaming Assets Marketplace
;; Mint and transfer gaming asset NFTs on-chain

(define-constant err-not-owner (err u100))
(define-constant err-nft-exists (err u101))
(define-constant err-nft-not-found (err u102))

;; Contract owner (marketplace admin)
(define-constant admin tx-sender)

;; Map token ID (uint) to owner principal
(define-map nft-owners uint principal)

;; Token counter for unique IDs
(define-data-var token-counter uint u0)

;; Mint a new gaming asset NFT (only admin)
(define-public (mint-nft (recipient principal))
  (begin
    (asserts! (is-eq tx-sender admin) err-not-owner)
    (let ((new-token-id (+ (var-get token-counter) u1)))
      (var-set token-counter new-token-id)
      (map-set nft-owners new-token-id recipient)
      (ok new-token-id)
    )
  )
)

;; Transfer NFT ownership
(define-public (transfer-nft (token-id uint) (new-owner principal))
  (let ((current-owner (map-get? nft-owners token-id)))
    (match current-owner
      owner
      (begin
        (asserts! (is-eq tx-sender owner) err-not-owner)
        (map-set nft-owners token-id new-owner)
        (ok true)
      )
      err-nft-not-found
    )
  )
)
