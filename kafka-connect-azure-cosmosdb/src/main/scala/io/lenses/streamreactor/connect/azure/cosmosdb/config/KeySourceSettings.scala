/*
 * Copyright 2017-2025 Lenses.io Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.lenses.streamreactor.connect.azure.cosmosdb.config

import io.lenses.streamreactor.common.config.base.traits.BaseSettings
import io.lenses.streamreactor.connect.azure.cosmosdb.config.CosmosDbConfigConstants.KEY_PATH_CONFIG
import io.lenses.streamreactor.connect.azure.cosmosdb.config.CosmosDbConfigConstants.KEY_SOURCE_CONFIG

trait KeySourceSettings extends BaseSettings {

  def getKeySource(): KeySource = {
    val pathConfig = getString(KEY_PATH_CONFIG)
    getString(KEY_SOURCE_CONFIG).toLowerCase match {
      case "key"       => KeyKeySource
      case "metadata"  => MetadataKeySource
      case "keypath"   => KeyPathKeySource(pathConfig)
      case "valuepath" => ValuePathKeySource(pathConfig)
    }
  }
}
