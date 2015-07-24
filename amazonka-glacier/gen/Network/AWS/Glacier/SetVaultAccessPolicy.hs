{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE RecordWildCards    #-}
{-# LANGUAGE TypeFamilies       #-}

{-# OPTIONS_GHC -fno-warn-unused-binds   #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- |
-- Module      : Network.AWS.Glacier.SetVaultAccessPolicy
-- Copyright   : (c) 2013-2015 Brendan Hay
-- License     : Mozilla Public License, v. 2.0.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- This operation configures an access policy for a vault and will
-- overwrite an existing policy. To configure a vault access policy, send a
-- PUT request to the @access-policy@ subresource of the vault. An access
-- policy is specific to a vault and is also called a vault subresource.
-- You can set one access policy per vault and the policy can be up to 20
-- KB in size. For more information about vault access policies, see
-- <http://docs.aws.amazon.com/amazonglacier/latest/dev/vault-access-policy.html Amazon Glacier Access Control with Vault Access Policies>.
--
-- <http://docs.aws.amazon.com/amazonglacier/latest/dev/api-SetVaultAccessPolicy.html>
module Network.AWS.Glacier.SetVaultAccessPolicy
    (
    -- * Request
      SetVaultAccessPolicy
    -- ** Request constructor
    , setVaultAccessPolicy
    -- ** Request lenses
    , svaprqPolicy
    , svaprqAccountId
    , svaprqVaultName

    -- * Response
    , SetVaultAccessPolicyResponse
    -- ** Response constructor
    , setVaultAccessPolicyResponse
    ) where

import           Network.AWS.Glacier.Types
import           Network.AWS.Prelude
import           Network.AWS.Request
import           Network.AWS.Response

-- | SetVaultAccessPolicy input.
--
-- /See:/ 'setVaultAccessPolicy' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'svaprqPolicy'
--
-- * 'svaprqAccountId'
--
-- * 'svaprqVaultName'
data SetVaultAccessPolicy = SetVaultAccessPolicy'
    { _svaprqPolicy    :: !(Maybe VaultAccessPolicy)
    , _svaprqAccountId :: !Text
    , _svaprqVaultName :: !Text
    } deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'SetVaultAccessPolicy' smart constructor.
setVaultAccessPolicy :: Text -> Text -> SetVaultAccessPolicy
setVaultAccessPolicy pAccountId_ pVaultName_ =
    SetVaultAccessPolicy'
    { _svaprqPolicy = Nothing
    , _svaprqAccountId = pAccountId_
    , _svaprqVaultName = pVaultName_
    }

-- | The vault access policy as a JSON string.
svaprqPolicy :: Lens' SetVaultAccessPolicy (Maybe VaultAccessPolicy)
svaprqPolicy = lens _svaprqPolicy (\ s a -> s{_svaprqPolicy = a});

-- | The @AccountId@ value is the AWS account ID of the account that owns the
-- vault. You can either specify an AWS account ID or optionally a single
-- apos@-@apos (hyphen), in which case Amazon Glacier uses the AWS account
-- ID associated with the credentials used to sign the request. If you use
-- an account ID, do not include any hyphens (apos-apos) in the ID.
svaprqAccountId :: Lens' SetVaultAccessPolicy Text
svaprqAccountId = lens _svaprqAccountId (\ s a -> s{_svaprqAccountId = a});

-- | The name of the vault.
svaprqVaultName :: Lens' SetVaultAccessPolicy Text
svaprqVaultName = lens _svaprqVaultName (\ s a -> s{_svaprqVaultName = a});

instance AWSRequest SetVaultAccessPolicy where
        type Sv SetVaultAccessPolicy = Glacier
        type Rs SetVaultAccessPolicy =
             SetVaultAccessPolicyResponse
        request = putJSON
        response = receiveNull SetVaultAccessPolicyResponse'

instance ToHeaders SetVaultAccessPolicy where
        toHeaders = const mempty

instance ToJSON SetVaultAccessPolicy where
        toJSON SetVaultAccessPolicy'{..}
          = object ["policy" .= _svaprqPolicy]

instance ToPath SetVaultAccessPolicy where
        toPath SetVaultAccessPolicy'{..}
          = mconcat
              ["/", toText _svaprqAccountId, "/vaults/",
               toText _svaprqVaultName, "/access-policy"]

instance ToQuery SetVaultAccessPolicy where
        toQuery = const mempty

-- | /See:/ 'setVaultAccessPolicyResponse' smart constructor.
data SetVaultAccessPolicyResponse =
    SetVaultAccessPolicyResponse'
    deriving (Eq,Read,Show,Data,Typeable,Generic)

-- | 'SetVaultAccessPolicyResponse' smart constructor.
setVaultAccessPolicyResponse :: SetVaultAccessPolicyResponse
setVaultAccessPolicyResponse = SetVaultAccessPolicyResponse'