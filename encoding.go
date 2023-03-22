package cardano

import (
	"encoding/hex"
	"fmt"

	"github.com/safanaj/cardano-go/internal/cbor"
)

var cborEnc, _ = cbor.CanonicalEncOptions().EncMode()
var cborDec, _ = cbor.DecOptions{MapKeyByteString: cbor.MapKeyByteStringWrap}.DecMode()

func getTypeFromCBORArray(data []byte) (uint64, error) {
	raw := []interface{}{}
	if err := cborDec.Unmarshal(data, &raw); err != nil {
		return 0, err
	}

	if len(raw) == 0 {
		return 0, fmt.Errorf("empty CBOR array")
	}

	t, ok := raw[0].(uint64)
	if !ok {
		return 0, fmt.Errorf("invalid Type")
	}

	return t, nil
}

func GetBytesFromCBORHex(cborHex string) ([]byte, error) {
	cborData, err := hex.DecodeString(cborHex)
	if err != nil {
		return nil, err
	}
	var data []byte
	err = cborDec.Unmarshal(cborData, &data)
	if err != nil {
		return nil, err
	}
	return data, nil
}
